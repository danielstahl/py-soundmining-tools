
from soundmining_tools import supercollider_client
from soundmining_tools.supercollider_client import SupercolliderClient
import logging


class BufNumAllocator:
    def __init__(self) -> None:
        self.reset()

    def reset(self) -> None:
        self.buf_num = 0

    def next(self) -> int:
        next_buf_num = self.buf_num
        self.buf_num = next_buf_num + 1
        return next_buf_num


class SoundPlay:
    def __init__(self, sound_path: str, start: float, end: float) -> None:
        self.sound_path = sound_path
        self.start = start
        self.end = end
        self.buf_num = None

    def absolut_time(self, time: float, rate: float) -> float:
        return abs((time - self.start) / rate)

    def duration(self, rate: float) -> float:
        return self.absolut_time(self.end, rate)

    def init(self, buf_num: int, client: SupercolliderClient) -> None:
        if not self.buf_num:
            self.buf_num = buf_num
            client.send_message(supercollider_client.alloc_read(buf_num, self.sound_path))
        else:
            logging.warn(f"{self.sound_path} is already allocated with buf num {self.buf_num}")

    def stop(self, client: SupercolliderClient) -> None:
        if self.buf_num:
            client.send_message(supercollider_client.free_buffer(self.buf_num))
            self.buf_num = None
        else:
            logging.warn(f"{self.sound_path} is not allocated")
