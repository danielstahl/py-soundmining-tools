from soundmining_tools import bus_allocator
from soundmining_tools.modular.instrument import Instrument, ControlInstrument
from soundmining_tools.bus_allocator import BusAllocator
from typing import Self


class StaticControl(ControlInstrument):
    def __init__(self, control_bus_allocator: BusAllocator) -> None:
        super().__init__("staticControl", control_bus_allocator)
        self.value = None

    def control(self, value: float) -> Self:
        self.value = value
        return self

    def graph(self, parent: list[Instrument]) -> list[Instrument]:
        return self.prepend_to_graph(parent)

    def internal_build(self, start_time: float, duration: float) -> list:
        return ["value", self.value]


class LineControl(ControlInstrument):
    def __init__(self,  output_bus_allocator: BusAllocator) -> None:
        super().__init__("lineControl", output_bus_allocator)

    def control(self, start_value: float, end_value: float) -> Self:
        self.start_value = start_value
        self.end_value = end_value
        return self

    def graph(self, parent: list[Instrument]) -> list[Instrument]:
        return self.prepend_to_graph(parent)

    def internal_build(self, start_time: float, duration: float) -> list:
        return [
            "startValue", self.start_value,
            "endValue", self.end_value]


class SineControl(ControlInstrument):
    def __init__(self, output_bus_allocator: BusAllocator) -> None:
        super().__init__("sineControl", output_bus_allocator)

    def control(self, start_value: float, peak_value: float) -> Self:
        self.start_value = start_value
        self.peak_value = peak_value
        return self

    def graph(self, parent: list[Instrument]) -> list[Instrument]:
        return self.prepend_to_graph(parent)

    def internal_build(self, start_time: float, duration: float) -> list:
        return [
            "startValue", self.start_value,
            "peakValue", self.peak_value]


class ControlInstruments:
    def __init__(self, control_bus_allocator: BusAllocator) -> None:
        self.control_bus_allocator = control_bus_allocator

    def static_control(self, value: float) -> StaticControl:
        return StaticControl(self.control_bus_allocator).control(value)

    def line_control(self, start_value: float, end_value: float) -> LineControl:
        return LineControl(self.control_bus_allocator).control(start_value, end_value)

    def sine_control(self, start_value: float, peak_value: float) -> SineControl:
        return SineControl(self.control_bus_allocator).control(start_value, peak_value)
