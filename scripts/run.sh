#!/bin/zsh

# Log the initiation
echo "initiating..." >> /tmp/com.drucial.hyperdirmic.debug.log

# Navigate to the project root directory
cd "$(dirname "$0")/.."
CURRENT_DIR=$(pwd)

# Log the current directory
echo "Current directory: $CURRENT_DIR" >> /tmp/com.drucial.hyperdirmic.debug.log

# Activate virtual environment
VENV_PATH="$CURRENT_DIR/venv/bin/activate"
if [ -f "$VENV_PATH" ]; then
    echo "Found virtual environment activation script at $VENV_PATH" >> /tmp/com.drucial.hyperdirmic.debug.log
    source "$VENV_PATH"
    echo "Virtual environment activated" >> /tmp/com.drucial.hyperdirmic.debug.log
else
    echo "Failed to find virtual environment activation script at $VENV_PATH" >> /tmp/com.drucial.hyperdirmic.debug.log
    exit 1
fi

# Verify Python from virtual environment
which python >> /tmp/com.drucial.hyperdirmic.debug.log

# Set PYTHONPATH to the src directory
export PYTHONPATH="$CURRENT_DIR/src"
echo "PYTHONPATH set to $PYTHONPATH" >> /tmp/com.drucial.hyperdirmic.debug.log

# Log starting the script
echo "Running Hyperdirmic script" >> /tmp/com.drucial.hyperdirmic.debug.log

# Check if the main.py exists and is accessible
MAIN_PATH="$CURRENT_DIR/src/main.py"
if [ -f "$MAIN_PATH" ]; then
    echo "Found main.py at $MAIN_PATH" >> /tmp/com.drucial.hyperdirmic.debug.log
else
    echo "main.py not found at $MAIN_PATH" >> /tmp/com.drucial.hyperdirmic.debug.log
    exit 1
fi

# Set process name to "Hyperdirmic" and run the actual script with logging
echo "Executing: python -m src.main" >> /tmp/com.drucial.hyperdirmic.debug.log
exec -a Hyperdirmic python -m src.main >> /tmp/com.drucial.hyperdirmic.log 2>&1 || {
    echo "Failed to start Hyperdirmic: $?" >> /tmp/com.drucial.hyperdirmic.debug.log
}
