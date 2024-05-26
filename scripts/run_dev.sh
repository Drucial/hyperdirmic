#!/bin/zsh

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> /tmp/com.drucial.hyperdirmic.debug.log
}

log "Initiating..."

# Function to clean up processes
cleanup() {
    log "Cleaning up..."
    pkill -f hyperdirmic
    pkill -f "tail -f /tmp/com.drucial.hyperdirmic.log"
    pkill -P $$  # Kill child processes of this script
    exit 0
}

# Trap signals to clean up before exiting
trap cleanup SIGINT SIGTERM EXIT

# Terminate any existing Hyperdirmic processes
log "Terminating existing Hyperdirmic processes..."
pkill -f hyperdirmic

sleep 5

# Check if any hyperdirmic processes are still running
if pgrep -f hyperdirmic; then
    log "Failed to terminate Hyperdirmic application."
    exit 1
else
    log "Successfully terminated Hyperdirmic processes."
fi

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

# Run the actual script and monitor the log file
log "Executing: python -m src.main"
{
    exec -a hyperdirmic python -m src.main >> /tmp/com.drucial.hyperdirmic.log 2>&1
} &

# Get the PID of the background process
PID=$!

# Monitor the log file in real-time
tail -f /tmp/com.drucial.hyperdirmic.log &

# Wait for the background process to complete
wait $PID

# Log the completion
log "Hyperdirmic script finished with exit code $?"
