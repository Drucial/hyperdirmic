import logging
import os
import shutil
import sys
import time
import signal

from watchdog.events import FileSystemEventHandler
from watchdog.observers import Observer
from hyperdirmic.file_mappings import file_mappings  # Absolute import

# Setup logging
logging.basicConfig(
    filename="/tmp/hyperdirmic.log",
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s",
)

# PID file setup
pid_file = "/tmp/hyperdirmic.pid"


def check_pid(pid):
    """Check for the existence of a unix pid."""
    try:
        os.kill(pid, 0)
    except OSError:
        return False
    else:
        return True


def cleanup():
    if os.path.exists(pid_file):
        os.remove(pid_file)
    logging.info("Cleanup complete.")


if os.path.isfile(pid_file):
    with open(pid_file, "r") as file:
        old_pid = file.read()
    if check_pid(int(old_pid)):
        logging.error("Script is already running.")
        sys.exit()
    else:
        os.remove(pid_file)

with open(pid_file, "w") as file:
    file.write(str(os.getpid()))


class Handler(FileSystemEventHandler):
    def __init__(self):
        super().__init__()
        logging.info("Handler initialized.")
        self.mapping = file_mappings

    def on_created(self, event):
        if event.is_directory:
            logging.info(f"Directory created: {event.src_path}, ignoring...")
            return
        file_path = event.src_path
        file_type = self.get_file_type(file_path)
        if file_type:
            self.organize_file(file_path, file_type)

    def get_file_type(self, file_path):
        _, extension = os.path.splitext(file_path)
        return extension[1:].lower() if extension else None

    def organize_file(self, file_path, file_type):
        destination_dir = self.get_destination_dir(file_type)
        filename = os.path.basename(file_path).lstrip(".")
        src = os.path.join(os.path.dirname(file_path), filename)

        while not os.path.exists(src):
            time.sleep(0.1)
        time.sleep(1)

        if os.path.exists(src):
            if not os.path.exists(destination_dir):
                os.makedirs(destination_dir)
                logging.info(f"Created directory {destination_dir}")

            dest = os.path.join(destination_dir, filename)
            dest = self.resolve_filename_conflict(dest)

            shutil.move(src, dest)
            logging.info(f"Moved {src} to {dest}")
        else:
            logging.warning(f"File {src} does not exist.")

    def resolve_filename_conflict(self, dest):
        if not os.path.exists(dest):
            return dest
        base, extension = os.path.splitext(dest)
        counter = 1
        new_dest = f"{base}_{counter}{extension}"
        while os.path.exists(new_dest):
            counter += 1
            new_dest = f"{base}_{counter}{extension}"
        return new_dest

    def get_destination_dir(self, file_type):
        downloads_dir = os.path.expanduser("~/Downloads")
        return os.path.join(downloads_dir, self.mapping.get(file_type, "OtherFiles"))


if __name__ == "__main__":
    def signal_handler(sig, frame):
        logging.info("Received signal to terminate, cleaning up...")
        observer.stop()
        observer.join()
        cleanup()
        sys.exit(0)

    signal.signal(signal.SIGINT, signal_handler)
    signal.signal(signal.SIGTERM, signal_handler)

    logging.info("Starting observer...")
    paths_to_watch = [
        os.path.expanduser("~/Desktop"),
        os.path.expanduser("~/Downloads"),
    ]
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
    cleanup()
