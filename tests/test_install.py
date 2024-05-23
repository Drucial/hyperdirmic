import os
import subprocess
import pytest
import time

def log(message):
    print(f"[{time.strftime('%Y-%m-%d %H:%M:%S')}] {message}")

@pytest.mark.order(1)
def test_installation(setup_and_teardown):
    log("Running installation test...")

    # Get the relative path to the test install script within the test_hyperdirmic directory
    install_script_path = os.path.join("scripts", "test_install.sh")
    log(f"Install script path: {install_script_path}")

    # Run the test installation script and capture output
    result = subprocess.run([install_script_path], capture_output=True, text=True)
    log(result.stdout)
    log(result.stderr)

    if result.returncode != 0:
        log(f"Installation script failed with return code {result.returncode}")
        raise subprocess.CalledProcessError(result.returncode, install_script_path)

    # Verify virtual environment is created
    assert os.path.exists("venv"), "Failed to create virtual environment."

    # Verify launch agent is created
    assert os.path.exists(
        os.path.expanduser("~/Library/LaunchAgents/com.drucial.hyperdirmic.plist")
    ), "Failed to create launch agent."

    # Verify utility commands are added to the mock .zshrc
    with open(os.getenv("ZSHRC"), "r") as f:
        content = f.read()
        assert (
            "# Hyperdirmic utility commands" in content
        ), "Failed to add utility commands to mock .zshrc."

    log("Installation test completed successfully.")
