import sys
 
# setting path
sys.path.append('.')
sys.path.append('../parentdirectory')

from soundmining_tools import supercollider_client
from soundmining_tools import supercollider_receiver
import time
import logging

logging.basicConfig(level=logging.INFO)

receiver = supercollider_receiver.SuperColliderReceiver()
receiver.start()
logging.info("Started supercollider receiver")
time.sleep(10)
receiver.stop()
logging.info("Stopped supercollider receiver")
"""
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