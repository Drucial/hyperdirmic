# src/set_folder_icon.sh
#!/bin/bash

FOLDER_PATH="$1"
ICON_PATH="$2"

# Copy the .icns file to the folder
cp "$ICON_PATH" "$FOLDER_PATH/Icon\r"

# Set the attributes so Finder uses the custom icon
/usr/bin/SetFile -a C "$FOLDER_PATH"

