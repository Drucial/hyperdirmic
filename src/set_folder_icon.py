import logging
import os
from Cocoa import NSWorkspace, NSImage

def set_folder_icon(directory_path, icon_path):
    logging.info(f"Setting icon for directory '{directory_path}' with icon '{icon_path}'.")

    try:
        icon = NSImage.alloc().initWithContentsOfFile_(icon_path)
        if not icon:
            logging.error(f"Unable to load icon file '{icon_path}'.")
            return

        success = NSWorkspace.sharedWorkspace().setIcon_forFile_options_(icon, directory_path, 0)
        if not success:
            logging.error(f"Unable to set icon for directory '{directory_path}'.")
        else:
            logging.info(f"Icon set for directory '{directory_path}' with icon '{icon_path}'.")
    except Exception as e:
        logging.error(f"An error occurred: {e}")

if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO)
    
    # Ensure to provide the absolute paths to the directory and icon file
    directory_path = os.path.abspath('/Users/drucial/Downloads/Documents')
    icon_path = os.path.abspath('/Users/drucial/Dev/hyperdirmic/assets/images/folder_icon.icns')
    
    set_folder_icon(directory_path, icon_path)
