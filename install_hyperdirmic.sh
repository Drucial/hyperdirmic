#!/bin/zsh

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

# Determine the location of .zshrc
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

# Add utility commands for Hyperdirmic to .zshrc
echo "\n# Hyperdirmic utility commands" >> "$ZSHRC"
echo "alias organize='source $(pwd)/venv/bin/activate && python $(pwd)/hyperdirmic/hyperdirmic.py'" >> "$ZSHRC"
echo "alias killhyperdirmic='pkill -f hyperdirmic.py'" >> "$ZSHRC"
echo "alias loghyperdirmic='cat /tmp/com.drucial.hyperdirmic.out'" >> "$ZSHRC"
echo "alias errorhyperdirmic='cat /tmp/com.drucial.hyperdirmic.err'" >> "$ZSHRC"

# Source the .zshrc file to apply changes
source "$ZSHRC"

# Install and configure launch agent
plist_data="<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
<plist version=\"1.0\">
<dict>
    <key>Label</key>
    <string>com.drucial.hyperdirmic</string>
    <key>ProgramArguments</key>
    <array>
        <string>$(pwd)/venv/bin/python3</string>
        <string>$(pwd)/hyperdirmic/hyperdirmic.py</string>
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

# Run the Hyperdirmic app
cd "$(pwd)" && ./venv/bin/python3 hyperdirmic/hyperdirmic.py &

# Notify user about setup completion
echo "Setup complete! Hyperdirmic will now run at login and automatically organize desktop and downloads files."
