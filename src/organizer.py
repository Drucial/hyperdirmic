import logging
import os
import shutil
import time
from set_folder_icon import set_folder_icon


def organize_file(file_path, file_type, file_mappings):
    destination_dir = get_destination_dir(file_type, file_mappings)
    filename = os.path.basename(file_path).lstrip(".")
    src = os.path.join(os.path.dirname(file_path), filename)

    logging.info(f"Attempting to move file: {src}")

    while not os.path.exists(src):
        time.sleep(0.1)
    time.sleep(1)

    try:
        if os.path.exists(src):
            if not os.path.exists(destination_dir):
                os.makedirs(destination_dir)
                logging.info(f"Created directory {destination_dir}")

                # Set custom folder icon
                script_dir = os.path.dirname(__file__)
                icon_path = os.path.join(script_dir, '../assets/images/folder_dark.icns')
                set_folder_icon(destination_dir, icon_path)

            new_filename = filename
            counter = 1
            while os.path.exists(os.path.join(destination_dir, new_filename)):
                name, ext = os.path.splitext(filename)
                new_filename = f"{name}_{counter}{ext}"
                counter += 1

            shutil.move(src, os.path.join(destination_dir, new_filename))
            logging.info(f"Moved {src} to {destination_dir}/{new_filename}")
        else:
            logging.warning(f"File {src} does not exist.")
    except Exception as e:
        logging.error(f"Failed to move file {src} to {destination_dir}: {e}")


def get_destination_dir(file_type, file_mappings):
    downloads_dir = os.path.expanduser("~/Downloads")
    if file_type not in file_mappings:
        logging.info(f"File type {file_type} not found in mappings. Using 'Misc'.")
    destination_dir = os.path.join(downloads_dir, file_mappings.get(file_type, "Misc"))
    logging.info(f"Destination directory for {file_type} is {destination_dir}")
    return destination_dir
