#!/bin/bash

# Function to set the folder icon using AppleScript
change_folder_icon() {
    local folderPath="$1"
    local iconPath="$2"
    osascript <<EOF
    set folderPath to POSIX file "$folderPath" as alias
    set iconPath to POSIX file "$iconPath" as alias

    tell application "Finder"
        set targetFolder to folderPath
        set iconFile to iconPath
        set targetFolder's icon to iconFile's icon
    end tell
EOF
}

# Main script execution

# Check if the correct number of arguments is provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 /path/to/folder /path/to/icon.icns"
    exit 1
fi

FOLDER_PATH="$1"
ICON_PATH="$2"

# Validate input paths
if [ ! -d "$FOLDER_PATH" ]; then
    echo "Error: Folder path is invalid."
    exit 1
fi

if [ ! -f "$ICON_PATH" ]; then
    echo "Error: Icon path is invalid or the file does not exist."
    exit 1
fi

# Change the folder icon
change_folder_icon "$FOLDER_PATH" "$ICON_PATH"

echo "Folder icon has been successfully changed."
