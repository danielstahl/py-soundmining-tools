
from soundmining_tools import supercollider_client
from soundmining_tools.supercollider_client import SupercolliderClient
from soundmining_tools.modular.instrument import AudioInstrument, ControlInstrument, AddAction
from soundmining_tools.modular.audio_instruments import AudioInstruments
from soundmining_tools.modular.control_instruments import ControlInstruments

from typing import Self


class SynthPlayer:
    def __init__(self, client: SupercolliderClient, 
                 audio_instruments: AudioInstruments, 
                 control_instruments: ControlInstruments) -> None:
        self.client = client
        self.audio_instruments = audio_instruments
        self.control_instruments = control_instruments

    def note(self) -> 'SynthNote':
        return SynthNote(self)


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

    def sine(self, freq: ControlInstrument, amp: ControlInstrument) -> Self:
        sine = self.synth_player.audio_instruments.sine_osc(amp, freq).add_action(AddAction.TAIL_ACTION)
        self.audio_stack.push(sine)
        return self

    def pan(self, pan_position: ControlInstrument) -> Self:
        in_audio = self.audio_stack.pop()
        panning = self.synth_player.audio_instruments.panning(in_audio, pan_position) \
            .add_action(AddAction.TAIL_ACTION)
        self.audio_stack.push(panning)
        return self

    def play(self, start_time: float, duration: float, output_bus: int = 0) -> None:
        client = self.synth_player.client
        audio_graph = self.audio_stack.pop() \
            .static_output_bus(output_bus) \
            .build_graph(start_time, duration)
        osc_messages = supercollider_client.new_synths(audio_graph)
        bundle = client.make_bundle(start_time, osc_messages)
        client.schedule_bundle(bundle)
