#!/bin/zsh

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> /tmp/com.drucial.hyperdirmic.debug.log
}

log "Initiating..."

# Navigate to the project root directory
cd "$(dirname "$0")/.."
CURRENT_DIR=$(pwd)

# Log the current directory
log "Current directory: $CURRENT_DIR"

# Activate virtual environment
VENV_PATH="$CURRENT_DIR/venv/bin/activate"
if [ -f "$VENV_PATH" ]; then
    log "Found virtual environment activation script at $VENV_PATH"
    source "$VENV_PATH"
    log "Virtual environment activated"
else
    log "Failed to find virtual environment activation script at $VENV_PATH"
    exit 1
fi

# Verify Python from virtual environment
which python >> /tmp/com.drucial.hyperdirmic.debug.log

# Set PYTHONPATH to the project root/src directory
export PYTHONPATH="$CURRENT_DIR/src"
log "PYTHONPATH set to $PYTHONPATH"

# Log starting the script
log "Running Hyperdirmic script"

# Check if the main.py exists and is accessible
MAIN_PATH="$CURRENT_DIR/src/main.py"
if [ -f "$MAIN_PATH" ]; then
    log "Found main.py at $MAIN_PATH"
else
    log "main.py not found at $MAIN_PATH"
    exit 1
fi

# Set process name to "Hyperdirmic" and run the actual script with logging
log "Executing: python -m src.main"
exec -a Hyperdirmic python -m src.main >> /tmp/com.drucial.hyperdirmic.log 2>&1 || {
    log "Failed to start Hyperdirmic: $?"
    exit 1
}
