#!/bin/zsh

# Kill any existing hyperdirmic processes
pkill -f hyperdirmic.py

# Unload and remove the launch agent
if [ -f ~/Library/LaunchAgents/com.drucial.hyperdirmic.plist ]; then
    launchctl unload ~/Library/LaunchAgents/com.drucial.hyperdirmic.plist
    rm -f ~/Library/LaunchAgents/com.drucial.hyperdirmic.plist
    echo "Unloaded and removed launch agent."
fi

# Remove the virtual environment
if [ -d venv ]; then
    rm -rf venv
    echo "Removed virtual environment."
fi

# Determine the location of .zshrc
if [ -f ~/.zshrc ]; then
    ZSHRC=~/.zshrc
elif [ -f ~/.config/zsh/.zshrc ]; then
    ZSHRC=~/.config/zsh/.zshrc
elif [ -f ~/.zprofile ]; then
    ZSHRC=~/.zprofile
else
    echo "No .zshrc or .zprofile found. Please specify the path to your zsh configuration file:"
    read -r ZSHRC
fi

# Remove utility commands from .zshrc
if [ -f "$ZSHRC" ]; then
    sed -i '' '/# Hyperdirmic utility commands/,+5d' "$ZSHRC"
    echo "Removed Hyperdirmic utility commands from $ZSHRC."
fi

# Reload the .zshrc file to apply changes
source "$ZSHRC"

# Notify user about uninstall completion
echo "Uninstall complete! Hyperdirmic has been removed from your system."

