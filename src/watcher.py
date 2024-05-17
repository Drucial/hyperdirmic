# src/watcher.py

import logging
import os
from watchdog.events import FileSystemEventHandler
from organizer import organize_file
from utils.file_mappings import file_mappings

class Handler(FileSystemEventHandler):
    def __init__(self):
        super().__init__()
        logging.info("Handler initialized.")
        self.file_mappings = file_mappings

    def on_created(self, event):
        if event.is_directory:
            logging.info(f"Directory created: {event.src_path}, ignoring...")
            return
        logging.info(f"File created: {event.src_path}")
        file_path = event.src_path
        file_type = self.get_file_type(file_path)
        if file_type:
            logging.info(f"File type detected: {file_type}. Organizing...")
            organize_file(file_path, file_type, self.file_mappings)
        else:
            logging.warning(f"File type not recognized for file: {file_path}")

    def get_file_type(self, file_path):
        _, extension = os.path.splitext(file_path)
        file_type = extension[1:].lower() if extension else None
        logging.info(f"Extracted file type: {file_type} from file: {file_path}")
        return file_type
