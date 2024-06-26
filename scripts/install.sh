#!/bin/zsh

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

log "Starting installation script..."

log "Terminating existing Hyperdirmic processes..."
pkill -f "hyperdirmic"

if pgrep -f "hyperdirmic"; then
    log "Failed to terminate Hyperdirmic application."
    exit 1
else
    log "Successfully terminated Hyperdirmic processes."
fi

if [ -f ~/Library/LaunchAgents/com.drucial.hyperdirmic.plist ]; then
    log "Unloading existing launch agent..."
    launchctl unload ~/Library/LaunchAgents/com.drucial.hyperdirmic.plist
    rm -f ~/Library/LaunchAgents/com.drucial.hyperdirmic.plist
fi

log "Creating virtual environment..."
python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt

log "Virtual environment and dependencies installed."

ZSHRC=
possible_locations=(
    ~/.zshrc
    ~/.config/zsh/.zshrc
    ~/.zprofile
)

for location in "${possible_locations[@]}"; do
    if [ -f "$location" ]; then
        ZSHRC="$location"
        log "Found configuration file at $ZSHRC"
        break
    fi
done

if [ -z "$ZSHRC" ]; then
    log "No .zshrc or .zprofile found. Please specify the path to your zsh configuration file:"
    read -r ZSHRC
fi

if [ -f "$ZSHRC" ]; then
    log "Removing existing Hyperdirmic utility commands from $ZSHRC..."
    sed -i '' '/# Hyperdirmic utility commands/,+6d' "$ZSHRC"
fi

log "Adding Hyperdirmic utility commands to $ZSHRC..."
{
    echo "\n# Hyperdirmic utility commands"
    echo "alias organize='source $(dirname "$0")/venv/bin/activate && PYTHONPATH=$(dirname "$0") python -m src.main'"
    echo "alias killhyperdirmic='pkill -f \"python -m src.main\"'"
    echo "alias loghyperdirmic='cat /tmp/com.drucial.hyperdirmic.out'"
    echo "alias errorhyperdirmic='cat /tmp/com.drucial.hyperdirmic.err'"
    echo "alias debughyperdirmic='cat /tmp/com.drucial.hyperdirmic.debug.log'"
    echo "alias allhyperdirmiclogs='cat /tmp/hyperdirmic.log /tmp/com.drucial.hyperdirmic.out /tmp/com.drucial.hyperdirmic.err /tmp/com.drucial.hyperdirmic.debug.log'"
} >> "$ZSHRC"

if [ -f "$ZSHRC" ]; then
    log "Sourcing $ZSHRC to apply changes immediately."
    source "$ZSHRC"
    if [[ $? -eq 0 ]]; then
        log "Successfully sourced $ZSHRC."
    else
        log "Failed to source $ZSHRC."
    fi
fi

log "Utility commands added to $ZSHRC and sourced."

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

log "Creating and loading launch agent..."
plist_data="<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
<plist version=\"1.0\">
<dict>
    <key>Label</key>
    <string>com.drucial.hyperdirmic</string>
    <key>ProgramArguments</key>
    <array>
        <string>$SCRIPT_DIR/run.sh</string>
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

if ! launchctl load ~/Library/LaunchAgents/com.drucial.hyperdirmic.plist; then
    log "Failed to load the launch agent. Please check the error log for more details at /tmp/com.drucial.hyperdirmic.err"
    exit 1
fi

log "Launch agent loaded successfully."

log "Starting the Hyperdirmic app..."
cd "$SCRIPT_DIR" && ./run.sh &

sleep 5
if pgrep -f hyperdirmic; then
    log "Hyperdirmic is running."
else
    log "Failed to start Hyperdirmic."
    exit 1
fi

log "Setup complete! Hyperdirmic will now run at login and automatically organize desktop and downloads files."
