
import logging
import concurrent.futures
from pythonosc.dispatcher import Dispatcher
from pythonosc.osc_server import BlockingOSCUDPServer


class SuperColliderReceiver:
    def __init__(self) -> None:
        self.executor = concurrent.futures.ThreadPoolExecutor(max_workers=1)

    def default_handler(address: str, *args: list[any]) -> None:
        print(f"handle {address}: {args}")

    def run_supercollider_server(self) -> None:
        self.server.serve_forever()

    def start(self) -> None:
        logging.info("Start supercollider receiver")
        dispatcher = Dispatcher()
        dispatcher.set_default_handler(SuperColliderReceiver.default_handler)
        self.server = BlockingOSCUDPServer(("127.0.0.1", 57111), dispatcher)
        self.executor.submit(self.run_supercollider_server)

    def stop(self) -> None:
        logging.info("Stop supercollider receiver")
        self.server.shutdown()
