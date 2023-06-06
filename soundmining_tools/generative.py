import random
from typing import TypeVar, Generic


def random_range(min: float, max: float) -> float:
    return random.uniform(min, max)


def random_int_range(min: int, max: int) -> int:
    return random.randint(min, max)


T = TypeVar('T')


def pick_items(items: list[T], size) -> list[T]:
    return random.choices(items, k=size)


class WeightedRandom(Generic[T]):

    def make_sorted_pairs(self,
                          pairs: list[tuple[T, float]]) -> list[tuple[T, float]]:
        probability_sum = 0
        for (value, probability) in pairs:
            probability_sum = probability_sum + probability
        fact = 1.0 / probability_sum
        result = []
        for (value, probability) in pairs:
            result.append((value, probability * fact))
        return result

    def __init__(self, pairs: list[tuple[T, float]]) -> None:
        self.sorted_pairs = self.make_sorted_pairs(pairs)

    def choose_value(self, weighted_random: float,
                     pairs_to_choose: list[tuple[T, float]]) -> T:
        head, *tail = pairs_to_choose
        (head_item, head_probbility) = head
        if weighted_random <= head_probbility:
            return head_item
        else:
            return self.choose_value(weighted_random - head_probbility, tail)

    def choose(self) -> T:
        return self.choose_value(random.random(), self.sorted_pairs)
