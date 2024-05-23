#!/bin/zsh

export CI=true

# Run the main uninstall script
./scripts/uninstall.sh

# Additional cleanup for testing (if any)
# e.g., removing test directories, deleting mock data, etc.

