
from soundmining_tools import supercollider_client
from soundmining_tools.supercollider_client import SupercolliderClient
from soundmining_tools.modular.instrument import AudioInstrument, ControlInstrument, AddAction
from soundmining_tools.modular.audio_instruments import AudioInstruments
from soundmining_tools.modular.control_instruments import ControlInstruments
from soundmining_tools.modular.sound_play import SoundPlay
from soundmining_tools.modular.sound_play import BufNumAllocator
from typing import Self


class SynthPlayer:
    def __init__(self, client: SupercolliderClient,
                 audio_instruments: AudioInstruments,
                 control_instruments: ControlInstruments,
                 buf_num_allocator: BufNumAllocator) -> None:
        self.client = client
        self.audio_instruments = audio_instruments
        self.control_instruments = control_instruments
        self.buf_num_allocator = buf_num_allocator
        self.sound_plays = {}

    def note(self) -> 'SynthNote':
        return SynthNote(self)

    def add_sound(self, name: str, sound_path: str, start: float, end: float) -> Self:
        self.sound_plays[name] = SoundPlay(sound_path, start, end)
        return self

    def get_sound(self, name) -> SoundPlay:
        return self.sound_plays[name]

    def start(self) -> Self:
        self.buf_num_allocator.reset()
        for sound_play in self.sound_plays.values():
            sound_play.init(self.buf_num_allocator.next(), self.client)
        return self

    def stop(self) -> Self:
        for sound_play in self.sound_plays.values():
            sound_play.stop(self.client)
        self.buf_num_allocator.reset()
        return self


class AudioStack:
    def __init__(self) -> None:
        self.audio_stack = []
        self.duration = 0.0

    def push(self, instrument: AudioInstrument, duration: float = None) -> None:
        self.audio_stack.append(instrument)
        if duration:
            self.duration = max(self.duration, duration)

    def pop(self) -> AudioInstrument:
        return self.audio_stack.pop()


class SynthNote:
    def __init__(self, synth_player: SynthPlayer) -> None:
        self.synth_player = synth_player
        self.audio_stack = AudioStack()

    def sound_mono(self, sound: str, rate: float, amp: ControlInstrument) -> Self:
        synth_player = self.synth_player
        sound_play = synth_player.get_sound(sound)
        mono_play_buffer = synth_player.audio_instruments \
            .mono_play_buffer(sound_play.buf_num, rate, sound_play.start, sound_play.end, amp) \
            .add_action(AddAction.TAIL_ACTION)
        duration = sound_play.duration(rate)
        self.audio_stack.push(mono_play_buffer, duration)
        return self

    def sine(self, freq: ControlInstrument, amp: ControlInstrument) -> Self:
        sine = self.synth_player.audio_instruments.sine_osc(amp, freq).add_action(AddAction.TAIL_ACTION)
        self.audio_stack.push(sine)
        return self

    def triangle(self, freq: ControlInstrument, amp: ControlInstrument) -> Self:
        triangle = self.synth_player.audio_instruments.triangle_osc(amp, freq).add_action(AddAction.TAIL_ACTION)
        self.audio_stack.push(triangle)
        return self

    def pulse(self, freq: ControlInstrument, amp: ControlInstrument) -> Self:
        pulse = self.synth_player.audio_instruments.pulse_osc(amp, freq).add_action(AddAction.TAIL_ACTION)
        self.audio_stack.push(pulse)
        return self

    def saw(self, freq: ControlInstrument, amp: ControlInstrument) -> Self:
        saw = self.synth_player.audio_instruments.saw_osc(amp, freq).add_action(AddAction.TAIL_ACTION)
        self.audio_stack.push(saw)
        return self

    def dust(self, freq: ControlInstrument, amp: ControlInstrument) -> Self:
        dust = self.synth_player.audio_instruments.dust_osc(amp, freq).add_action(AddAction.TAIL_ACTION)
        self.audio_stack.push(dust)
        return self

    def white_noise(self, amp: ControlInstrument) -> Self:
        noise = self.synth_player.audio_instruments.white_noise_osc(amp).add_action(AddAction.TAIL_ACTION)
        self.audio_stack.push(noise)
        return self

    def pink_noise(self, amp: ControlInstrument) -> Self:
        noise = self.synth_player.audio_instruments.pink_noise_osc(amp).add_action(AddAction.TAIL_ACTION)
        self.audio_stack.push(noise)
        return self

    def bank_of_osc(self, freqs: list[float], amps: list[float], phases: list[float]) -> Self:
        bank = self.synth_player.audio_instruments.bank_of_osc(freqs, amps, phases).add_action(AddAction.TAIL_ACTION)
        self.audio_stack.push(bank)
        return self

    def bank_of_resonators(self, in_bus: AudioInstrument,
                           freqs: list[float],
                           amps: list[float],
                           ring_times: list[float]) -> Self:
        bank = self.synth_player.audio_instruments.bank_of_resonators(in_bus, freqs, amps, ring_times) \
            .add_action(AddAction.TAIL_ACTION)
        self.audio_stack.push(bank)
        return self

    def mono_volume(self, amp: ControlInstrument) -> Self:
        in_bus = self.audio_stack.pop()
        volume = self.synth_player.audio_instruments.mono_volume(in_bus, amp).add_action(AddAction.TAIL_ACTION)
        self.audio_stack.push(volume)
        return self

    def stereo_volume(self, amp: ControlInstrument) -> Self:
        in_bus = self.audio_stack.pop()
        volume = self.synth_player.audio_instruments.stereo_volume(in_bus, amp).add_action(AddAction.TAIL_ACTION)
        self.audio_stack.push(volume)
        return self

    def pan(self, pan_position: ControlInstrument) -> Self:
        in_audio = self.audio_stack.pop()
        panning = self.synth_player.audio_instruments.panning(in_audio, pan_position) \
            .add_action(AddAction.TAIL_ACTION)
        self.audio_stack.push(panning)
        return self

    def play(self, start_time: float, duration: float = None, output_bus: int = 0) -> None:
        final_duration = duration or self.audio_stack.duration

        client = self.synth_player.client
        audio_graph = self.audio_stack.pop() \
            .static_output_bus(output_bus) \
            .build_graph(start_time, final_duration)
        osc_messages = supercollider_client.new_synths(audio_graph)
        bundle = client.make_bundle(start_time, osc_messages)
        client.schedule_bundle(bundle)
