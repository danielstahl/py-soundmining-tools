from soundmining_tools import supercollider_client
from soundmining_tools.supercollider_client import SupercolliderClient
from soundmining_tools import bus_allocator
from soundmining_tools.modular_v2 import instruments_v2
from soundmining_tools.modular_v2 import synth_player_v2
from soundmining_tools.modular import instrument
from soundmining_tools.supercollider_receiver import SuperColliderReceiver

V2_SYNTH_DIR = "/Users/danielstahl/Documents/Projects/py-soundmining-tools/sc/synths-v2"


class PieceV2:
    def start(self, should_send_to_score: bool = False) -> None:
        self.supercollider_client = SupercolliderClient()
        self.supercollider_client.start()
        self.audio_bus_allocator = bus_allocator.BusAllocator(64)
        self.instruments = instruments_v2.InstrumentsV2(self.audio_bus_allocator)
        self.synth_player = synth_player_v2.SynthPlayerV2(self.supercollider_client, self.instruments,
                                                          should_send_to_score=should_send_to_score)
        instrument.setup_nodes(self.supercollider_client)
        instrument.load_synth_dir(self.supercollider_client, synth_dir=V2_SYNTH_DIR)
        receiver = SuperColliderReceiver()
        receiver.start()
        self.receiver = receiver

    def stop(self) -> None:
        self.supercollider_client.stop()
        self.synth_player.stop()
        self.receiver.stop()

    def reset(self) -> None:
        self.synth_player.client.send_message(supercollider_client.clear_sched())
        self.synth_player.client.send_message(supercollider_client.deep_free(0))        
        self.audio_bus_allocator.reset_allocations()
        self.supercollider_client.reset_clock()

    def reset_deep(self) -> None:
        instrument.setup_nodes(self.supercollider_client)
        instrument.load_synth_dir(self.supercollider_client, V2_SYNTH_DIR)


piece_v2 = PieceV2()
