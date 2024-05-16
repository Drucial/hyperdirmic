#!/bin/zsh

echo "Starting uninstallation script..."

# Kill any existing hyperdirmic processes
pkill -f src.main

# Check if plist file exists and unload it if it does
if [ -f ~/Library/LaunchAgents/com.drucial.hyperdirmic.plist ]; then
    launchctl unload ~/Library/LaunchAgents/com.drucial.hyperdirmic.plist
    rm -f ~/Library/LaunchAgents/com.drucial.hyperdirmic.plist
    echo "Launch agent unloaded and plist file removed."
else
    echo "No plist file found to unload."
fi

# Remove virtual environment
if [ -d "$(dirname "$0")/../venv" ]; then
    rm -rf "$(dirname "$0")/../venv"
    echo "Virtual environment removed."
else
    echo "No virtual environment found to remove."
fi

# Remove utility commands from .zshrc or .zprofile
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

# Remove utility commands if present
if [ -f "$ZSHRC" ]; then
    sed -i '' '/# Hyperdirmic utility commands/,+5d' "$ZSHRC"
    echo "Utility commands removed from $ZSHRC."
fi

# Clear the logs
rm -f /tmp/hyperdirmic.log
rm -f /tmp/com.drucial.hyperdirmic.err
rm -f /tmp/com.drucial.hyperdirmic.out
rm -f /tmp/com.drucial.hyperdirmic.debug.log
echo "Logs cleared."

# Remove __pycache__ directories
find . -name "__pycache__" -type d -exec rm -r {} +
echo "__pycache__ directories removed."

echo "Uninstallation complete! Hyperdirmic has been removed."
