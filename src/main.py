# src/main.py

import logging
import os
import sys
import time
from watchdog.observers import Observer
from src.watcher import Handler
from src.utils.logger import setup_logging

def main():
    setup_logging()
    logging.info("Hyperdirmic main function started")
    pid_file = '/tmp/hyperdirmic.pid'

    def check_pid(pid):
        try:
            os.kill(pid, 0)
        except OSError:
            return False
        else:
            return True

    if os.path.isfile(pid_file):
        with open(pid_file, 'r') as file:
            old_pid = file.read()
        if check_pid(int(old_pid)):
            logging.error("Script is already running.")
            sys.exit()
        else:
            os.remove(pid_file)

    with open(pid_file, 'w') as file:
        file.write(str(os.getpid()))

    logging.info("Starting observer...")
    paths_to_watch = [os.path.expanduser("~/Desktop"), os.path.expanduser("~/Downloads")]
    event_handler = Handler()
    observer = Observer()
    for path in paths_to_watch:
        observer.schedule(event_handler, path, recursive=False)
    observer.start()

    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        logging.info("Stopping observer...")
        observer.stop()
    observer.join()
    logging.info("Observer stopped.")

    if os.path.exists(pid_file):
        os.remove(pid_file)
        logging.info("PID file removed.")

if __name__ == "__main__":
    logging.info("Executing main.py")
    main()
