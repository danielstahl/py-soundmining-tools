from soundmining_tools.modular.instrument import Instrument, ControlInstrument, AudioInstrument
from soundmining_tools.bus_allocator import BusAllocator
from typing import Self


class OscInstrument(AudioInstrument):
    def __init__(self, instrument_name: str, output_bus_allocator: BusAllocator) -> None:
        super().__init__(instrument_name, 1, output_bus_allocator)

    def osc(self, amp_bus: ControlInstrument, freq_bus: ControlInstrument) -> Self:
        self.amp_bus = amp_bus
        self.freq_bus = freq_bus
        return self

    def graph(self, parent: list[Instrument]) -> list[Instrument]:
        return self.append_to_graph(self.amp_bus.graph(self.freq_bus.graph(parent)))

    def internal_build(self, start_time: float, duration: float) -> list:
        return [
            "freqBus", self.freq_bus.dynamic_output_bus(start_time, duration),
            "ampBus", self.amp_bus.dynamic_output_bus(start_time, duration)
        ]


class SineOsc(OscInstrument):
    def __init__(self, audio_bus_allocator: BusAllocator) -> None:
        super().__init__("sineOsc", audio_bus_allocator)


class TriangleOsc(OscInstrument):
    def __init__(self, audio_bus_allocator: BusAllocator) -> None:
        super().__init__("triangleOsc", audio_bus_allocator)


class PulseOsc(OscInstrument):
    def __init__(self, audio_bus_allocator: BusAllocator) -> None:
        super().__init__("pulseOsc", audio_bus_allocator)


class SawOsc(OscInstrument):
    def __init__(self, audio_bus_allocator: BusAllocator) -> None:
        super().__init__("sawOsc", audio_bus_allocator)


class DustOsc(OscInstrument):
    def __init__(self, audio_bus_allocator: BusAllocator) -> None:
        super().__init__("dustOsc", audio_bus_allocator)


class NoiseOscInstrument(AudioInstrument):
    def __init__(self, instrument_name: str, output_bus_allocator: BusAllocator) -> None:
        super().__init__(instrument_name, 1, output_bus_allocator)

    def noise(self, amp_bus: ControlInstrument) -> Self:
        self.amp_bus = amp_bus
        return self

    def graph(self, parent: list[Instrument]) -> list[Instrument]:
        return self.append_to_graph(self.amp_bus.graph(parent))

    def internal_build(self, start_time: float, duration: float) -> list:
        return [
            "ampBus", self.amp_bus.dynamic_output_bus(start_time, duration)
        ]


class WhiteNoiseOsc(NoiseOscInstrument):
    def __init__(self, audio_bus_allocator: BusAllocator) -> None:
        super().__init__("whiteNoiseOsc", audio_bus_allocator)


class PinkNoiseOsc(NoiseOscInstrument):
    def __init__(self, audio_bus_allocator: BusAllocator) -> None:
        super().__init__("pinkNoiseOsc", audio_bus_allocator)


class BankOfOsc(AudioInstrument):
    def __init__(self, output_bus_allocator: BusAllocator) -> None:
        super().__init__("bankOfOsc", 1, output_bus_allocator)

    def bank_of_osc(self, freqs: list[float], amps: list[float], phases: list[float]) -> Self:
        self.freqs = freqs
        self.amps = amps
        self.phases = phases
        return self

    def graph(self, parent: list[Instrument]) -> list[Instrument]:
        return self.append_to_graph(parent)

    def internal_build(self, start_time: float, duration: float) -> list:
        return [
            "freqs", self.freqs,
            "amps", self.amps,
            "phases", self.phases
        ]


class BankOfResonators(AudioInstrument):
    def __init__(self, output_bus_allocator: BusAllocator) -> None:
        super().__init__("bankOfResonators", 1, output_bus_allocator)

    def bank_of_resonators(self, in_bus: AudioInstrument,
                           freqs: list[float], 
                           amps: list[float], 
                           ring_times: list[float]) -> Self:
        self.in_bus = in_bus
        self.freqs = freqs
        self.amps = amps
        self.ring_times = ring_times
        return self

    def graph(self, parent: list[Instrument]) -> list[Instrument]:
        return self.append_to_graph(self.in_bus.graph(parent))

    def internal_build(self, start_time: float, duration: float) -> list:
        return [
            "in", self.in_bus.dynamic_output_bus(start_time, duration),
            "freqs", self.freqs,
            "amps", self.amps,
            "ringTimes", self.ring_times
        ]


class PlayBuffer(AudioInstrument):
    def __init__(self, instrument_name: str, nr_of_channels: int, output_bus_allocator: BusAllocator) -> None:
        super().__init__(instrument_name, nr_of_channels, output_bus_allocator)

    def play_buffer(self, buf_num: int, rate: float, start: float, end: float, amp_bus: ControlInstrument) -> Self:
        self.buf_num = buf_num
        self.rate = rate
        self.start = start
        self.end = end
        self.amp_bus = amp_bus
        return self

    def graph(self, parent: list[Instrument]) -> list[Instrument]:
        return self.append_to_graph(self.amp_bus.graph(parent))

    def internal_build(self, start_time: float, duration: float) -> list:
        return [
            "bufNum", self.buf_num,
            "rate", self.rate,
            "start", self.start,
            "end", self.end,
            "ampBus", self.amp_bus.dynamic_output_bus(start_time, duration)
        ]


class MonoPlayBuffer(PlayBuffer):
    def __init__(self, output_bus_allocator: BusAllocator) -> None:
        super().__init__("monoPlayBuffer", 1, output_bus_allocator)


class StereoPlayBuffer(PlayBuffer):
    def __init__(self, output_bus_allocator: BusAllocator) -> None:
        super().__init__("stereoPlayBuffer", 2, output_bus_allocator)


class Volume(AudioInstrument):
    def __init__(self, instrument_name: str, nr_of_channels: int, output_bus_allocator: BusAllocator) -> None:
        super().__init__(instrument_name, nr_of_channels, output_bus_allocator)

    def volume(self, in_bus: AudioInstrument, amp_bus: ControlInstrument) -> Self:
        self.in_bus = in_bus
        self.amp_bus = amp_bus
        return self

    def graph(self, parent: list[Instrument]) -> list[Instrument]:
        return self.append_to_graph(self.amp_bus.graph(self.in_bus.graph(parent)))

    def internal_build(self, start_time: float, duration: float) -> list:
        return [
            "in", self.in_bus.dynamic_output_bus(start_time, duration),
            "ampBus", self.amp_bus.dynamic_output_bus(start_time, duration)
        ]


class MonoVolume(Volume):
    def __init__(self, output_bus_allocator: BusAllocator) -> None:
        super().__init__("monoVolume", 1, output_bus_allocator)


class StereoVolume(Volume):
    def __init__(self, output_bus_allocator: BusAllocator) -> None:
        super().__init__("stereoVolume", 2, output_bus_allocator)


class Panning(AudioInstrument):
    def __init__(self, output_bus_allocator: BusAllocator) -> None:
        super().__init__("pan", 2, output_bus_allocator)

    def pan(self, in_bus: AudioInstrument, pan_bus: ControlInstrument) -> Self:
        self.in_bus = in_bus
        self.pan_bus = pan_bus
        return self

    def graph(self, parent: list[Instrument]) -> list[Instrument]:
        return self.append_to_graph(self.in_bus.graph(self.pan_bus.graph(parent)))

    def internal_build(self, start_time: float, duration: float) -> list:
        return [
            "in", self.in_bus.dynamic_output_bus(start_time, duration),
            "panBus", self.pan_bus.dynamic_output_bus(start_time, duration)]


class AudioInstruments:
    def __init__(self, audio_bus_allocator: BusAllocator) -> None:
        self.audio_bus_allocator = audio_bus_allocator

    def sine_osc(self, amp_bus: ControlInstrument, freq_bus: ControlInstrument) -> SineOsc:
        return SineOsc(self.audio_bus_allocator).osc(amp_bus, freq_bus)

    def triangle_osc(self, amp_bus: ControlInstrument, freq_bus: ControlInstrument) -> TriangleOsc:
        return TriangleOsc(self.audio_bus_allocator).osc(amp_bus, freq_bus)

    def pulse_osc(self, amp_bus: ControlInstrument, freq_bus: ControlInstrument) -> PulseOsc:
        return PulseOsc(self.audio_bus_allocator).osc(amp_bus, freq_bus)

    def saw_osc(self, amp_bus: ControlInstrument, freq_bus: ControlInstrument) -> SawOsc:
        return SawOsc(self.audio_bus_allocator).osc(amp_bus, freq_bus)

    def dust_osc(self, amp_bus: ControlInstrument, freq_bus: ControlInstrument) -> DustOsc:
        return DustOsc(self.audio_bus_allocator).osc(amp_bus, freq_bus)

    def white_noise_osc(self, amp_bus: ControlInstrument) -> WhiteNoiseOsc:
        return WhiteNoiseOsc(self.audio_bus_allocator).osc(amp_bus)

    def pink_noise_osc(self, amp_bus: ControlInstrument) -> PinkNoiseOsc:
        return PinkNoiseOsc(self.audio_bus_allocator).osc(amp_bus)

    def bank_of_osc(self, freqs: list[float], amps: list[float], phases: list[float]) -> BankOfOsc:
        return BankOfOsc(self.audio_bus_allocator).bank_of_osc(freqs, amps, phases)

    def bank_of_resonators(self, in_bus: AudioInstrument,
                           freqs: list[float],
                           amps: list[float],
                           ring_times: list[float]) -> BankOfResonators:
        return BankOfResonators(self.audio_bus_allocator).bank_of_resonators(in_bus, freqs, amps, ring_times)

    def mono_play_buffer(self, buf_num: int, rate: float,
                         start: float, end: float, amp_bus: ControlInstrument) -> MonoPlayBuffer:
        return MonoPlayBuffer(self.audio_bus_allocator).play_buffer(buf_num, rate, start, end, amp_bus)

    def stereo_play_buffer(self, buf_num: int, rate: float,
                           start: float, end: float, amp_bus: ControlInstrument) -> StereoPlayBuffer:
        return StereoPlayBuffer(self.audio_bus_allocator).play_buffer(buf_num, rate, start, end, amp_bus)

    def mono_volume(self, in_bus: AudioInstrument, amp_bus: ControlInstrument) -> MonoVolume:
        return MonoVolume(self.audio_bus_allocator).volume(in_bus, amp_bus)

    def stereo_volume(self, in_bus: AudioInstrument, amp_bus: ControlInstrument) -> StereoVolume:
        return StereoVolume(self.audio_bus_allocator).volume(in_bus, amp_bus)

    def panning(self, in_bus: AudioInstrument, pan_bus: ControlInstrument) -> Panning:
        return Panning(self.audio_bus_allocator).pan(in_bus, pan_bus)
