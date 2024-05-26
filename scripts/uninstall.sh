#!/bin/zsh

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

log "Starting uninstallation script..."

log "Terminating existing Hyperdirmic processes..."
pkill -f hyperdirmic

if pgrep -f hyperdirmic; then
    log "Failed to terminate Hyperdirmic application."
    exit 1
else
    log "Successfully terminated Hyperdirmic processes."
fi

if [ -f ~/Library/LaunchAgents/com.drucial.hyperdirmic.plist ]; then
    log "Unloading existing launch agent..."
    launchctl unload ~/Library/LaunchAgents/com.drucial.hyperdirmic.plist
    rm -f ~/Library/LaunchAgents/com.drucial.hyperdirmic.plist
    log "Launch agent unloaded and plist file removed."
else
    log "No plist file found to unload."
fi

VENV_DIR="$(cd "$(dirname "$0")/.." && pwd)/venv"
if [ -d "$VENV_DIR" ]; then
    log "Removing virtual environment..."
    rm -rf "$VENV_DIR"
    log "Virtual environment removed."
else
    log "No virtual environment found to remove."
fi

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

if [ -f "$ZSHRC" ]; then
    log "Removing utility commands from $ZSHRC..."
    sed -i '' '/# Hyperdirmic utility commands/,+6d' "$ZSHRC"
    log "Utility commands removed from $ZSHRC."
fi

log "Clearing Hyperdirmic logs..."
rm -f /tmp/hyperdirmic.log
rm -f /tmp/com.drucial.hyperdirmic.err
rm -f /tmp/com.drucial.hyperdirmic.out
rm -f /tmp/com.drucial.hyperdirmic.debug.log
log "Logs cleared."

log "Removing __pycache__ directories..."
find . -name "__pycache__" -type d -exec rm -r {} +
log "__pycache__ directories removed."

log "Uninstallation complete! Hyperdirmic has been removed."
