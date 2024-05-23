import os
import subprocess
import pytest
import time

def log(message):
    print(f"[{time.strftime('%Y-%m-%d %H:%M:%S')}] {message}")

@pytest.mark.order(2)
def test_uninstallation(setup_and_teardown):
    log("Running uninstallation test...")

    # Get the relative path to the uninstall script within the test_hyperdirmic directory
    uninstall_script_path = os.path.join("scripts", "test_uninstall.sh")
    log(f"Uninstall script path: {uninstall_script_path}")

    # Run the uninstallation script and capture output
    result = subprocess.run([uninstall_script_path], capture_output=True, text=True)
    log(result.stdout)
    log(result.stderr)

    if result.returncode != 0:
        log(f"Uninstallation script failed with return code {result.returncode}")
        raise subprocess.CalledProcessError(result.returncode, uninstall_script_path)

    # Verify virtual environment is removed
    assert not os.path.exists("venv"), "Failed to remove virtual environment."

    # Verify launch agent is removed
    assert not os.path.exists(
        os.path.expanduser("~/Library/LaunchAgents/com.drucial.hyperdirmic.plist")
    ), "Failed to remove launch agent."

    # Verify utility commands are removed from the mock .zshrc
    with open(os.getenv("ZSHRC"), "r") as f:
        content = f.read()
        assert (
            "# Hyperdirmic utility commands" not in content
        ), "Failed to remove utility commands from mock .zshrc."

    log("Uninstallation test completed successfully.")
