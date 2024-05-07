#!/bin/zsh

# Make hyperdirmic.py executable
chmod +x hyperdirmic.py

# Add an alias for hyperdirmic_setup.py in .zshrc
echo "alias organize=\"$(pwd)/hyperdirmic_setup.py\"" >> ~/.zshrc

# Install launch agent
plist_data="<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
<plist version=\"1.0\">
<dict>
    <key>Label</key>
    <string>com.drucial.hyperdirmic</string>
    <key>ProgramArguments</key>
    <array>
        <string>/usr/bin/python</string>
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

# Notify user about setup completion
echo "Setup complete! Hyperdirmic will now run at login and automatically desktop and downloads files."
:
