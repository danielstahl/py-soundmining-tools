from soundmining_tools.supercollider_client import SupercolliderClient
from soundmining_tools import bus_allocator
from soundmining_tools.modular import audio_instruments, control_instruments
from soundmining_tools.modular import synth_player
from soundmining_tools.modular import instrument
from soundmining_tools.modular.sound_play import BufNumAllocator
from soundmining_tools.supercollider_receiver import SuperColliderReceiver


class Piece:
    def start(self, should_send_to_score: bool = False) -> None:
        self.supercollider_client = SupercolliderClient()
        self.supercollider_client.start()
        self.control_bus_allocator = bus_allocator.BusAllocator(0)
        self.audio_bus_allocator = bus_allocator.BusAllocator(64)
        self.audio_instruments = audio_instruments.AudioInstruments(self.audio_bus_allocator)
        self.control_instruments = control_instruments.ControlInstruments(self.control_bus_allocator)
        self.buf_num_allocator = BufNumAllocator()
        self.synth_player = synth_player.SynthPlayer(self.supercollider_client,
                                                     self.audio_instruments,
                                                     self.control_instruments,
                                                     self.buf_num_allocator,
                                                     should_send_to_score=should_send_to_score)
        instrument.setup_nodes(self.supercollider_client)
        instrument.load_synth_dir(self.supercollider_client)
        receiver = SuperColliderReceiver()
        receiver.start()
        self.receiver = receiver

    def stop(self) -> None:
        self.supercollider_client.stop()
        self.synth_player.stop()
        self.receiver.stop()

    def reset(self) -> None:
        self.control_bus_allocator.reset_allocations()
        self.audio_bus_allocator.reset_allocations()
        self.supercollider_client.reset_clock()


piece = Piece()
