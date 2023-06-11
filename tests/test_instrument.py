import unittest
from soundmining_tools.modular.instrument import Instrument, ControlInstrument, AudioInstrument, Bus, AddAction
from soundmining_tools import bus_allocator
from typing import Self

control_bus_allocator = bus_allocator.BusAllocator(0)
audio_bus_allocator = bus_allocator.BusAllocator(64)


class StaticControl(ControlInstrument):
    def __init__(self) -> None:
        super().__init__("staticControl", control_bus_allocator)
        self.value = None

    def control(self, value: float) -> Self:
        self.value = value
        return self

    def graph(self, parent: list[Instrument]) -> list[Instrument]:
        return self.prepend_to_graph(parent)

    def internal_build(self, start_time: float, duration: float) -> list:
        return ["value", self.value]


class SineOsc(AudioInstrument):
    def __init__(self) -> None:
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


class TestInstrument(unittest.TestCase):

    def test_dynamic_bus(self) -> None:
        allocator = bus_allocator.BusAllocator(64)
        bus = Bus(allocator, 2)
        allocated_bus = bus.dynamic_bus(0, 1)
        self.assertEqual(allocated_bus, 64)

    def test_static_bus(self) -> None:
        allocator = bus_allocator.BusAllocator(64)
        bus = Bus(allocator, 2)
        bus.static_bus(0)
        allocated_bus = bus.dynamic_bus(0, 1)
        self.assertEqual(allocated_bus, 0)

    def test_single_instrument(self) -> None:
        control_bus_allocator.reset_allocations()
        audio_bus_allocator.reset_allocations()
        result = StaticControl() \
            .control(5) \
            .build_graph(0, 2)
        expected = [
            ["staticControl", -1, 0, 1004, "out", 0, "dur", 2, "value", 5]
        ]
        self.assertEqual(result, expected)

    def test_audio_with_control(self) -> None:
        control_bus_allocator.reset_allocations()
        audio_bus_allocator.reset_allocations()
        freq = StaticControl().control(440.0)
        amp = StaticControl().control(1.0)
        sine = SineOsc() \
            .sine(amp, freq) \
            .add_action(AddAction.TAIL_ACTION) \
            .static_output_bus(0)

        result = sine.build_graph(0, 2)
        expected = [
            ["staticControl", -1, 0, 1004, "out", 0, "dur", 2, "value", 1.0],
            ["staticControl", -1, 0, 1004, "out", 1, "dur", 2, "value", 440.0],
            ["sineOsc", -1, 1, 1004, "out", 0, "dur", 2, "freqBus", 1, "ampBus", 0]
        ]
        self.assertEqual(result, expected)


if __name__ == '__main__':
    unittest.main()
