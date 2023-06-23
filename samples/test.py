import sys
 
# setting path
sys.path.append('.')
sys.path.append('../parentdirectory')

from soundmining_tools import supercollider_client
from soundmining_tools import bus_allocator
from soundmining_tools.modular import audio_instruments, control_instruments
from soundmining_tools.modular.instrument import Bus, AddAction, NodeId, setup_nodes, load_synth_dir
import time
import logging

logging.basicConfig(level=logging.INFO)


control_bus_allocator = bus_allocator.BusAllocator(0)
audio_bus_allocator = bus_allocator.BusAllocator(64)
audio_instruments = audio_instruments.AudioInstruments(audio_bus_allocator)
control_instruments = control_instruments.ControlInstruments(control_bus_allocator)
freq = control_instruments.static_control(440.0)
amp = control_instruments.static_control(1.0)
sine = audio_instruments.sine_osc(amp, freq) \
    .add_action(AddAction.TAIL_ACTION) \
    .static_output_bus(0)
graph = sine.build_graph(0, 2)
osc_messages = supercollider_client.new_synths(graph)

client = supercollider_client.SupercolliderClient()
client.start()
setup_nodes(client)
load_synth_dir(client)

bundle = client.make_bundle(0, osc_messages)
client.schedule_bundle(bundle)

bundle = client.make_bundle(2, osc_messages)
client.schedule_bundle(bundle)

time.sleep(10)
client.stop()
"""
receiver = supercollider_receiver.SuperColliderReceiver()
receiver.start()
logging.info("Started supercollider receiver")
time.sleep(10)
receiver.stop()
logging.info("Stopped supercollider receiver")

logging.info("creating client")
client = supercollider_client.SupercolliderClient()
logging.info("starting client")
client.start()
group_head = supercollider_client.group_head(0, 1004)
logging.info("send message")
client.send_message(group_head)
new_synth = supercollider_client.new_synth("default", 0, 0, ["dur", 0.1, "freq", 110])
new_synth_bundle = client.make_bundle(1.0, [new_synth])
client.schedule_bundle(new_synth_bundle)
time.sleep(10)
client.stop()
"""
