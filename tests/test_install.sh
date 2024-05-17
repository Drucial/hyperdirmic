#!/bin/zsh

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

setup_test_env() {
    log "Setting up test environment..."

    # Ensure a clean state before running tests
    ../scripts/uninstall.sh

    # Prepare a fresh clone of the repository for testing
    if [ -d "./test_hyperdirmic" ]; then
        rm -rf ./test_hyperdirmic
    fi

    git clone .. ./test_hyperdirmic
    cd ./test_hyperdirmic

    # Create a mock .zshrc file in the test directory
    echo "Creating mock .zshrc file..."
    echo "# Mock .zshrc for testing" > .zshrc
    export ZSHRC=$(pwd)/.zshrc

    # Backup the actual .zshrc to simulate it not being found
    if [ -f ~/.zshrc ]; then
        mv ~/.zshrc ~/.zshrc.bak
    fi
    if [ -f ~/.config/zsh/.zshrc ]; then
        mv ~/.config/zsh/.zshrc ~/.config/zsh/.zshrc.bak
    fi
    if [ -f ~/.zprofile ]; then
        mv ~/.zprofile ~/.zprofile.bak
    fi

    log "Test environment setup complete."
}

teardown_test_env() {
    log "Tearing down test environment..."

    # Restore the original .zshrc and .zprofile files
    if [ -f ~/.zshrc.bak ]; then
        mv ~/.zshrc.bak ~/.zshrc
    fi
    if [ -f ~/.config/zsh/.zshrc.bak ]; then
        mv ~/.config/zsh/.zshrc.bak ~/.config/zsh/.zshrc
    fi
    if [ -f ~/.zprofile.bak ]; then
        mv ~/.zprofile.bak ~/.zprofile
    fi

    # Clean up the test environment
    cd ..
    rm -rf ./test_hyperdirmic

    log "Test environment teardown complete."
}

test_installation() {
    log "Running installation test..."

    # Simulate user input for specifying the .zshrc file location using expect
    expect <<EOF
    spawn ./scripts/install.sh
    expect "Please specify the path to your zsh configuration file:"
    send -- "$ZSHRC\r"
    expect eof
EOF

    # Check if virtual environment is created
    if [ -d "venv" ]; then
        log "Virtual environment created successfully."
    else
        log "Failed to create virtual environment."
        return 1
    fi

    # Check if launch agent is installed
    if [ -f ~/Library/LaunchAgents/com.drucial.hyperdirmic.plist ]; then
        log "Launch agent created successfully."
    else
        log "Failed to create launch agent."
        return 1
    fi

    # Check if utility commands are added to the mock .zshrc
    if grep -q "# Hyperdirmic utility commands" $ZSHRC; then
        log "Utility commands added to mock .zshrc successfully."
    else
        log "Failed to add utility commands to mock .zshrc."
        return 1
    fi

    log "Installation test completed successfully."
}

test_uninstallation() {
    log "Running uninstallation test..."

    # Simulate user input for specifying the .zshrc file location using expect
    expect <<EOF
    spawn ./scripts/uninstall.sh
    expect "Please specify the path to your zsh configuration file:"
    send -- "$ZSHRC\r"
    expect eof
EOF

    # Check if virtual environment is removed
    if [ ! -d "venv" ]; then
        log "Virtual environment removed successfully."
    else
        log "Failed to remove virtual environment."
        return 1
    fi

    # Check if launch agent is removed
    if [ ! -f ~/Library/LaunchAgents/com.drucial.hyperdirmic.plist ]; then
        log "Launch agent removed successfully."
    else
        log "Failed to remove launch agent."
        return 1
    fi

    # Check if utility commands are removed from the mock .zshrc
    if ! grep -q "# Hyperdirmic utility commands" $ZSHRC; then
        log "Utility commands removed from mock .zshrc successfully."
    else
        log "Failed to remove utility commands from mock .zshrc."
        return 1
    fi

    log "Uninstallation test completed successfully."
}

main() {
    setup_test_env

    # Ensure teardown is called on exit
    trap teardown_test_env EXIT

    test_installation
    INSTALL_STATUS=$?
    if [ $INSTALL_STATUS -ne 0 ]; then
        log "Installation test failed."
        exit 1
    fi

    test_uninstallation
    UNINSTALL_STATUS=$?
    if [ $UNINSTALL_STATUS -ne 0 ]; then
        log "Uninstallation test failed."
        exit 1
    fi

    log "All tests passed successfully!"
}

main "$@"
