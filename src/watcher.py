import logging
import os
import shutil
import time

from watchdog.events import FileSystemEventHandler

from utils.file_mappings import file_mappings

from .organizer import organize_file


class Handler(FileSystemEventHandler):
    def __init__(self):
        super().__init__()
        logging.info("Handler initialized.")
        self.file_mappings = file_mappings

    def on_created(self, event):
        if event.is_directory:
            logging.info(f"Directory created: {event.src_path}, ignoring...")
            return
        file_path = event.src_path
        file_type = self.get_file_type(file_path)
        if file_type:
            organize_file(file_path, file_type, self.file_mappings)

    def get_file_type(self, file_path):
        _, extension = os.path.splitext(file_path)
        return extension[1:].lower() if extension else None
