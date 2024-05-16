#!/bin/zsh

# Activate virtual environment
source "$(dirname "$0")/../venv/bin/activate"

# Set PYTHONPATH to the current directory
export PYTHONPATH="$(dirname "$0")/.."

# Log starting the script
echo "Running Hyperdirmic script" >> /tmp/com.drucial.hyperdirmic.debug.log
echo "PYTHONPATH=$PYTHONPATH" >> /tmp/com.drucial.hyperdirmic.debug.log
echo "Virtual environment activated" >> /tmp/com.drucial.hyperdirmic.debug.log

# Set process name to "Hyperdirmic" and run the actual script with logging
exec -a Hyperdirmic python -m hyperdirmic.hyperdirmic >> /tmp/com.drucial.hyperdirmic.log 2>&1
