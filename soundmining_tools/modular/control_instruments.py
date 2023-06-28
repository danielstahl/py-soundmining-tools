from soundmining_tools import bus_allocator
from soundmining_tools.modular.instrument import Instrument, ControlInstrument
from soundmining_tools.bus_allocator import BusAllocator
from typing import Self
from typing import TypeVar, Generic

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


LEVELS_T = TypeVar('LEVELS_T', bound='tuple[float, ...]')
TIMES_T = TypeVar('TIMES_T', bound='tuple[float, ...]')
CURVES_T = TypeVar('CURVES_T', bound='tuple[float, ...]')


class BlockControl(ControlInstrument):
    def __init__(self, instrument_name, output_bus_allocator: BusAllocator) -> None:
        super().__init__(instrument_name, output_bus_allocator)

    def _control(self, levels: LEVELS_T, times: TIMES_T, curves: CURVES_T) -> Self:
        self.levels = levels
        self.times = times
        self.curves = curves
        return self

    def graph(self, parent: list[Instrument]) -> list[Instrument]:
        return self.prepend_to_graph(parent)

    def internal_build(self, start_time: float, duration: float) -> list:
        return [
            "levels", list(self.levels),
            "times", list(self.times),
            "curves", list(self.curves)]


class TwoBLockControl(BlockControl):
    def __init__(self, output_bus_allocator: BusAllocator) -> None:
        super().__init__("twoBlockControl", output_bus_allocator)

    def control(self, levels: tuple[float, float, float],
                times: tuple[float, float],
                curves: tuple[float, float]) -> Self:
        return super()._control(levels, times, curves)


class ThreeBLockControl(BlockControl):
    def __init__(self, output_bus_allocator: BusAllocator) -> None:
        super().__init__("threeBlockControl", output_bus_allocator)

    def control(self, levels: tuple[float, float, float, float],
                times: tuple[float, float, float],
                curves: tuple[float, float, float]) -> Self:
        return super()._control(levels, times, curves)


class FourBLockControl(BlockControl):
    def __init__(self, output_bus_allocator: BusAllocator) -> None:
        super().__init__("fourBlockControl", output_bus_allocator)

    def control(self, levels: tuple[float, float, float, float, float],
                times: tuple[float, float, float, float],
                curves: tuple[float, float, float, float]) -> Self:
        return super()._control(levels, times, curves)


class ControlInstruments:
    def __init__(self, control_bus_allocator: BusAllocator) -> None:
        self.control_bus_allocator = control_bus_allocator

    def static_control(self, value: float) -> StaticControl:
        return StaticControl(self.control_bus_allocator).control(value)

    def line_control(self, start_value: float, end_value: float) -> LineControl:
        return LineControl(self.control_bus_allocator).control(start_value, end_value)

    def sine_control(self, start_value: float, peak_value: float) -> SineControl:
        return SineControl(self.control_bus_allocator).control(start_value, peak_value)

    def two_block_control(self, levels: tuple[float, float, float],
                          times: tuple[float, float],
                          curves: tuple[float, float]) -> TwoBLockControl:
        return TwoBLockControl(self.control_bus_allocator).control(levels, times, curves)

    def three_block_control(self, levels: tuple[float, float, float, float],
                            times: tuple[float, float, float],
                            curves: tuple[float, float, float]) -> ThreeBLockControl:
        return ThreeBLockControl(self.control_bus_allocator).control(levels, times, curves)

    def four_block_control(self, levels: tuple[float, float, float, float, float],
                           times: tuple[float, float, float, float],
                           curves: tuple[float, float, float, float]) -> ThreeBLockControl:
        return FourBLockControl(self.control_bus_allocator).control(levels, times, curves)
