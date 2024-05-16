#!/bin/zsh

echo "Starting installation script..."

# Kill any existing hyperdirmic processes
echo "Terminating existing Hyperdirmic processes..."
pkill -f hyperdirmic.main

# Check if any hyperdirmic processes are still running
if pgrep -f hyperdirmic.main; then
    echo "Failed to terminate Hyperdirmic application."
    exit 1
else
    echo "Successfully terminated Hyperdirmic processes."
fi

# Check if plist file exists and unload it if it does
if [ -f ~/Library/LaunchAgents/com.drucial.hyperdirmic.plist ]; then
    echo "Unloading existing launch agent..."
    launchctl unload ~/Library/LaunchAgents/com.drucial.hyperdirmic.plist
    rm -f ~/Library/LaunchAgents/com.drucial.hyperdirmic.plist
fi

# Create a virtual environment and install required Python modules
echo "Creating virtual environment..."
python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip install watchdog

echo "Virtual environment and dependencies installed."

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
    echo "No .zshrc or .zprofile found. Please specify the path to your zsh configuration file:"
    read -r ZSHRC
fi

# Remove any existing Hyperdirmic utility commands from .zshrc or .zprofile
if [ -f "$ZSHRC" ]; then
    echo "Removing existing Hyperdirmic utility commands..."
    sed -i '' '/# Hyperdirmic utility commands/,+5d' "$ZSHRC"
fi

# Add utility commands for Hyperdirmic to .zshrc or .zprofile
echo "Adding Hyperdirmic utility commands to $ZSHRC..."
echo "\n# Hyperdirmic utility commands" >> "$ZSHRC"
echo "alias organize='source $(dirname "$0")/venv/bin/activate && PYTHONPATH=$(dirname "$0") python -m src.main'" >> "$ZSHRC"
echo "alias killhyperdirmic='pkill -f hyperdirmic.main'" >> "$ZSHRC"
echo "alias loghyperdirmic='cat /tmp/com.drucial.hyperdirmic.out'" >> "$ZSHRC"
echo "alias errorhyperdirmic='cat /tmp/com.drucial.hyperdirmic.err'" >> "$ZSHRC"

# Source the .zshrc file to apply changes, but only if it exists
if [ -f "$ZSHRC" ]; then
    source "$ZSHRC"
fi

echo "Utility commands added to $ZSHRC and sourced."

# Install and configure launch agent
echo "Creating and loading launch agent..."
plist_data="<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
<plist version=\"1.0\">
<dict>
    <key>Label</key>
    <string>com.drucial.hyperdirmic</string>
    <key>ProgramArguments</key>
    <array>
        <string>$(dirname "$0")/scripts/run.sh</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <dict>
      <key>SuccessfulExit</key>
      <false/>
    </dict>
    <key>StandardErrorPath</key>
    <string>/tmp/com.drucial.hyperdirmic.err</string>
    <key>StandardOutPath</key>
    <string>/tmp/com.drucial.hyperdirmic.out</string>
</dict>
</plist>"
echo "$plist_data" > ~/Library/LaunchAgents/com.drucial.hyperdirmic.plist

# Load launch agent and check for errors
if ! launchctl load ~/Library/LaunchAgents/com.drucial.hyperdirmic.plist; then
    echo "Failed to load the launch agent. Please check the error log for more details at /tmp/com.drucial.hyperdirmic.err"
    exit 1
fi

echo "Launch agent loaded successfully."

# Run the Hyperdirmic app
cd "$(dirname "$0")" && ./run.sh &

# Verify that Hyperdirmic is running
sleep 5
if pgrep -f src.main; then
    echo "Hyperdirmic is running."
else
    echo "Failed to start Hyperdirmic."
    exit 1
fi

echo "Setup complete! Hyperdirmic will now run at login and automatically organize desktop and downloads files."