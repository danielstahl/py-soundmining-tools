from soundmining_tools.modular.instrument import Instrument, ControlInstrument, AudioInstrument
from soundmining_tools.bus_allocator import BusAllocator
from typing import Self


class SineOsc(AudioInstrument):
    def __init__(self, audio_bus_allocator: BusAllocator) -> None:
        super().__init__("sineOsc", 1, audio_bus_allocator)
        self.amp_bus = None
        self.freq_bus = None

    def sine(self, amp_bus: ControlInstrument, freq_bus: ControlInstrument) -> Self:
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
        return SineOsc(self.audio_bus_allocator).sine(amp_bus, freq_bus)

    def panning(self, in_bus: AudioInstrument, pan_bus: ControlInstrument) -> Panning:
        return Panning(self.audio_bus_allocator).pan(in_bus, pan_bus)
