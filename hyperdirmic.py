import os
import shutil
import time

from watchdog.events import FileSystemEventHandler
from watchdog.observers import Observer


class Handler(FileSystemEventHandler):
    def __init__(self):
        super().__init__()
        self.mapping = {
            "txt": "TextFiles",
            "jpg": "Images",
            "png": "Images",
            # Add more file types and directories as needed
        }

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

    # Inside the Handler class
    def organize_file(self, file_path, file_type):
        destination_dir = self.get_destination_dir(file_type)
        filename = os.path.basename(file_path).lstrip(
            "."
        )  # Remove leading dot from filename
        src = os.path.join(
            os.path.dirname(file_path), filename
        )  # Construct source path without the leading period

        # Check if the file exists, waiting until it is fully created
        while not os.path.exists(src):
            time.sleep(0.1)  # Adjust the sleep time as needed
        # Add an additional delay to ensure the file is fully created
        time.sleep(1)  # Adjust the sleep time as needed

        if os.path.exists(src):  # Check if source file exists
            if not os.path.exists(destination_dir):
                os.makedirs(destination_dir)
            shutil.move(src, os.path.join(destination_dir, filename))
        else:
            print(f"File {src} does not exist.")

    def get_destination_dir(self, file_type):
        downloads_dir = os.path.expanduser("~/Downloads")
        destination_dir = os.path.join(
            downloads_dir, self.mapping.get(file_type, "OtherFiles")
        )
        if not os.path.exists(destination_dir):
            os.makedirs(destination_dir)
        return destination_dir


if __name__ == "__main__":
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
        observer.stop()
    observer.join()
