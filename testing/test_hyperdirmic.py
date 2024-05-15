import logging
import os
import shutil
import tempfile
import time

from watchdog.observers import Observer

from hyperdirmic.hyperdirmic import Handler  # Ensure correct import path

# Set up logging to file and console
logging.basicConfig(
    filename="/tmp/test_hyperdirmic.log",
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s",
)
console_handler = logging.StreamHandler()
console_handler.setLevel(logging.INFO)
formatter = logging.Formatter("%(asctime)s - %(levelname)s - %(message)s")
console_handler.setFormatter(formatter)
logging.getLogger().addHandler(console_handler)


def create_test_files(base_dir):
    test_files = {
        "image.jpg": "Images",
        "video.mp4": "Videos",
        "document.txt": "Documents",
        "executable.exe": "Apps",
        "archive.zip": "Archives",
        "code.py": "Code",
    }

    for file_name, expected_dir in test_files.items():
        file_path = os.path.join(base_dir, file_name)
        with open(file_path, "w") as f:
            f.write("This is a test file.")
        logging.info(f"Created test file: {file_path}")
        time.sleep(0.1)  # Ensure the file creation event is detected

    return test_files


def test_file_organizer():
    temp_dir = tempfile.mkdtemp()
    logging.info(f"Using temporary directory for test: {temp_dir}")

    handler = Handler()
    observer = Observer()
    observer.schedule(handler, temp_dir, recursive=False)
    observer.start()

    try:
        test_files = create_test_files(temp_dir)
        time.sleep(5)  # Wait for the handler to process the files

        for file_name, expected_dir in test_files.items():
            dest_dir = os.path.join(os.path.expanduser("~/Downloads"), expected_dir)
            dest_path = os.path.join(dest_dir, file_name)

            if os.path.exists(dest_path):
                logging.info(f"SUCCESS: {file_name} was moved to {dest_path}")
            else:
                logging.error(f"FAILURE: {file_name} was not found in {dest_dir}")

    except Exception as e:
        logging.error(f"An error occurred: {e}")

    finally:
        observer.stop()
        observer.join()
        shutil.rmtree(temp_dir)  # Clean up temporary directory
        logging.info(f"Cleaned up temporary directory: {temp_dir}")


if __name__ == "__main__":
    test_file_organizer()
