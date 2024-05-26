# src/set_folder_icon.py

import os
import subprocess

def set_folder_icon(directory_path, icon_path):
    try:
        subprocess.run(['./set_folder_icon.sh', directory_path, icon_path], check=True)
        print(f"Icon set for directory '{directory_path}' with icon '{icon_path}'.")
    except Exception as e:
        print(f"Failed to set icon for directory '{directory_path}': {e}")

