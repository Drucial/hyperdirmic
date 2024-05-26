#!/bin/zsh

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> /tmp/com.drucial.hyperdirmic.debug.log
}

log "Initiating..."

log "Terminating existing Hyperdirmic processes..."
pkill -f "hyperdirmic"

if pgrep -f "hyperdirmic"; then
    log "Failed to terminate Hyperdirmic application."
    exit 1
else
    log "Successfully terminated Hyperdirmic processes."
fi

cd "$(dirname "$0")/.."
CURRENT_DIR=$(pwd)

log "Current directory: $CURRENT_DIR"

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

export PYTHONPATH="$CURRENT_DIR/src"
log "PYTHONPATH set to $PYTHONPATH"

log "Running Hyperdirmic script"

MAIN_PATH="$CURRENT_DIR/src/main.py"
if [ -f "$MAIN_PATH" ]; then
    log "Found main.py at $MAIN_PATH"
else
    log "main.py not found at $MAIN_PATH"
    exit 1
fi

log "Executing: python -m src.main"
{
    exec -a Hyperdirmic python -m src.main >> /tmp/com.drucial.hyperdirmic.log 2>&1
} &

# Get the PID of the background process
PID=$!

# Monitor the log file in real-time
tail -f /tmp/com.drucial.hyperdirmic.log &

# Wait for the background process to complete
wait $PID

log "Hyperdirmic script finished with exit code $?"

