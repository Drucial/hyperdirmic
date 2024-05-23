#!/bin/zsh

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

log "Starting uninstallation script..."

# Determine if running in CI environment
if [ "$CI" = "true" ]; then
    PLIST_DIR="/tmp/Library/LaunchAgents"
    VENV_DIR="/tmp/hyperdirmic_test/venv"
    log "Running in CI environment. Using temporary directories."
else
    PLIST_DIR="$HOME/Library/LaunchAgents"
    VENV_DIR="$(cd "$(dirname "$0")/.." && pwd)/venv"
fi

# Kill any existing Hyperdirmic processes
pkill -f src.main

# Check if plist file exists and unload it if it does
if [ -f $PLIST_DIR/com.drucial.hyperdirmic.plist ]; then
    launchctl unload $PLIST_DIR/com.drucial.hyperdirmic.plist
    rm -f $PLIST_DIR/com.drucial.hyperdirmic.plist
    log "Launch agent unloaded and plist file removed."
else
    log "No plist file found to unload."
fi

# Remove virtual environment
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
    sed -i '' '/# Hyperdirmic utility commands/,+6d' "$ZSHRC"
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
