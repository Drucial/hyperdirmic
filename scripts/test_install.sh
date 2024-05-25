#!/bin/zsh

export CI=true

# Log start of the installation process
echo "Starting test installation script..."

# Run the main install script
./scripts/install.sh

# Log end of the installation process
echo "Test installation script completed."
