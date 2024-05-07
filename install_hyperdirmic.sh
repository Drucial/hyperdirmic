#!/bin/zsh

# Create a virtual environment and install required Python modules
python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip install watchdog

# Add aliases for Hyperdirmic setup to .zshrc
# echo "alias organize=\"$(pwd)/hyperdirmic_setup.py\"" >> ~/.zshrc
# echo "alias killhyperdirmic=\"pkill -f hyperdirmic.py\"" >> ~/.zshrc
# echo "alias log='show --predicate \"senderImagePath CONTAINS hyperdirmic\" --info'" >> ~/.zshrc

# Install and configure launch agent
plist_data="<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
<plist version=\"1.0\">
<dict>
    <key>Label</key>
    <string>com.drucial.hyperdirmic</string>
    <key>ProgramArguments</key>
    <array>
        <string>/usr/bin/python3</string>
        <string>$(pwd)/hyperdirmic.py</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
</dict>
</plist>"
echo "$plist_data" > ~/Library/LaunchAgents/com.drucial.hyperdirmic.plist

# Load launch agent
launchctl load ~/Library/LaunchAgents/com.drucial.hyperdirmic.plist
# Run the Hyperdirmic app
python hyperdirmic.py &

# Notify user about setup completion
echo "Setup complete! Hyperdirmic will now run at login and automatically organize desktop and downloads files."
