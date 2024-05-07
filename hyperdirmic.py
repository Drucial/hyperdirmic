import os
import shutil
import time

from watchdog.events import FileSystemEventHandler
from watchdog.observers import Observer


class Handler(FileSystemEventHandler):
    def on_created(self, event):
        if event.is_directory:
            return
        file_path = event.src_path
        file_type = self.get_file_type(file_path)
        if file_type:
            self.organize_file(file_path, file_type)

    def get_file_type(self, file_path):
        _, extension = os.path.splitext(file_path)
        if extension:
            return extension[1:].lower()  # Remove leading dot and convert to lowercase
        return None

    def organize_file(self, file_path, file_type):
        destination_dir = self.get_destination_dir(file_type)
        if not os.path.exists(destination_dir):
            os.makedirs(destination_dir)
        shutil.move(
            file_path, os.path.join(destination_dir, os.path.basename(file_path))
        )

    def get_destination_dir(self, file_type):
        # Define your directory mapping here based on file types
        mapping = {
            "txt": "TextFiles",
            "jpg": "Images",
            "png": "Images",
            # Add more file types and directories as needed
        }
        return mapping.get(file_type, "OtherFiles")


if __name__ == "__main__":
    paths_to_watch = [
        os.path.expanduser("~/Desktop"),
        os.path.expanduser("~/Downloads"),
    ]
    event_handler = MyHandler()
    observer = Observer()
    for path in paths_to_watch:
        observer.schedule(event_handler, path, recursive=False)
    observer.start()

    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        observer.stop()
    observer.join()
