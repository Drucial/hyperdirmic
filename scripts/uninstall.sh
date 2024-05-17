#!/bin/zsh

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

log "Starting uninstallation script..."

# Kill any existing Hyperdirmic processes
pkill -f src.main

# Check if plist file exists and unload it if it does
if [ -f ~/Library/LaunchAgents/com.drucial.hyperdirmic.plist ]; then
    launchctl unload ~/Library/LaunchAgents/com.drucial.hyperdirmic.plist
    rm -f ~/Library/LaunchAgents/com.drucial.hyperdirmic.plist
    log "Launch agent unloaded and plist file removed."
else
    log "No plist file found to unload."
fi

# Remove virtual environment
VENV_DIR="$(cd "$(dirname "$0")/.." && pwd)/venv"
if [ -d "$VENV_DIR" ]; then
    rm -rf "$VENV_DIR"
    log "Virtual environment removed."
else
    log "No virtual environment found to remove."
fi

# Determine the location of .zshrc or .zprofile
ZSHRC=
possible_locations=(
    ~/.zshrc
    ~/.config/zsh/.zshrc
    ~/.zprofile
)

for location in "${possible_locations[@]}"; do
    if [ -f "$location" ]; then
        ZSHRC="$location"
        break
    fi
done

if [ -z "$ZSHRC" ]; then
    log "No .zshrc or .zprofile found. Please specify the path to your zsh configuration file:"
    read -r ZSHRC
fi

# Remove utility commands if present
if [ -f "$ZSHRC" ]; then
    sed -i '' '/# Hyperdirmic utility commands/,+5d' "$ZSHRC"
    log "Utility commands removed from $ZSHRC."
fi

# Clear the logs
rm -f /tmp/hyperdirmic.log
rm -f /tmp/com.drucial.hyperdirmic.err
rm -f /tmp/com.drucial.hyperdirmic.out
rm -f /tmp/com.drucial.hyperdirmic.debug.log
log "Logs cleared."

# Remove __pycache__ directories
find . -name "__pycache__" -type d -exec rm -r {} +
log "__pycache__ directories removed."

log "Uninstallation complete! Hyperdirmic has been removed."
