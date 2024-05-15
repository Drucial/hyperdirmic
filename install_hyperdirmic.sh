#!/bin/zsh

# Debug information
echo "Starting installation script..."

# Kill any existing hyperdirmic processes
pkill -f hyperdirmic.py

# Check if plist file exists and unload it if it does
if [ -f ~/Library/LaunchAgents/com.drucial.hyperdirmic.plist ]; then
    launchctl unload ~/Library/LaunchAgents/com.drucial.hyperdirmic.plist
    rm -f ~/Library/LaunchAgents/com.drucial.hyperdirmic.plist
fi

# Create a virtual environment and install required Python modules
python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip install watchdog

# Debug information
echo "Virtual environment and dependencies installed."

# Determine the location of .zshrc or .zprofile
if [ -f ~/.zshrc ]; then
    ZSHRC=~/.zshrc
elif [ -f ~/.config/zsh/.zshrc ]; then
    ZSHRC=~/.config/zsh/.zshrc
elif [ -f ~/.zprofile ]; then
    ZSHRC=~/.zprofile
else
    echo "No .zshrc or .zprofile found. Please specify the path to your zsh configuration file:"
    read -r ZSHRC
fi

# Remove any existing Hyperdirmic utility commands from .zshrc or .zprofile
if [ -f "$ZSHRC" ]; then
    sed -i '' '/# Hyperdirmic utility commands/,+5d' "$ZSHRC"
fi

# Add utility commands for Hyperdirmic to .zshrc or .zprofile
echo "\n# Hyperdirmic utility commands" >> "$ZSHRC"
echo "alias organize='source $(pwd)/venv/bin/activate && PYTHONPATH=$(pwd) python -m hyperdirmic.hyperdirmic'" >> "$ZSHRC"
echo "alias killhyperdirmic='pkill -f hyperdirmic.py'" >> "$ZSHRC"
echo "alias loghyperdirmic='cat /tmp/com.drucial.hyperdirmic.out'" >> "$ZSHRC"
echo "alias errorhyperdirmic='cat /tmp/com.drucial.hyperdirmic.err'" >> "$ZSHRC"

# Source the .zshrc file to apply changes, but only if it exists
if [ -f "$ZSHRC" ]; then
    source "$ZSHRC"
fi

# Debug information
echo "Utility commands added to $ZSHRC and sourced."

# Install and configure launch agent
plist_data="<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
<plist version=\"1.0\">
<dict>
    <key>Label</key>
    <string>com.drucial.hyperdirmic</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/zsh</string>
        <string>-c</string>
        <string>cd $(pwd) && source ./venv/bin/activate && PYTHONPATH=$(pwd) ./venv/bin/python3 -m hyperdirmic.hyperdirmic</string>
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

# Debug information
echo "Launch agent plist created."

# Load launch agent and check for errors
if ! launchctl load ~/Library/LaunchAgents/com.drucial.hyperdirmic.plist; then
    echo "Failed to load the launch agent. Please check the error log for more details at /tmp/com.drucial.hyperdirmic.err"
    exit 1
fi

# Debug information
echo "Launch agent loaded successfully."

# Run the Hyperdirmic app
cd "$(pwd)" && PYTHONPATH=$(pwd) ./venv/bin/python3 -m hyperdirmic.hyperdirmic &

# Notify user about setup completion
echo "Setup complete! Hyperdirmic will now run at login and automatically organize desktop and downloads files."
