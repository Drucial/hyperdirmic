import os
import shutil
import subprocess
import time

import pytest

def log(message):
    print(f"[{time.strftime('%Y-%m-%d %H:%M:%S')}] {message}")

@pytest.fixture(scope="module")
def setup_and_teardown():
    # Setup: Prepare test environment
    log("Setting up test environment...")

    # Get the absolute path to the project root
    project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
    log(f"Project root: {project_root}")

    # Run the test uninstall script to ensure a clean state
    test_uninstall_script = os.path.join(project_root, "scripts", "test_uninstall.sh")
    if os.path.exists(test_uninstall_script):
        subprocess.run([test_uninstall_script], check=True)
    else:
        log(f"Test uninstall script not found at {test_uninstall_script}")

    # Create a clean clone of the repository for testing
    test_dir = "./test_hyperdirmic"
    if os.path.exists(test_dir):
        shutil.rmtree(test_dir)
    subprocess.run(["git", "clone", ".", test_dir], check=True)

    # Ensure the scripts are copied correctly to the test_hyperdirmic directory
    os.makedirs(os.path.join(test_dir, "scripts"), exist_ok=True)
    shutil.copy(
        os.path.join(project_root, "scripts", "test_install.sh"),
        os.path.join(test_dir, "scripts", "test_install.sh"),
    )
    shutil.copy(
        os.path.join(project_root, "scripts", "test_uninstall.sh"),
        os.path.join(test_dir, "scripts", "test_uninstall.sh"),
    )

    os.chdir(test_dir)
    log(f"Current directory: {os.getcwd()}")

    # Create a mock .zshrc file in the test directory
    log("Creating mock .zshrc file...")
    with open(".zshrc", "w") as f:
        f.write("# Mock .zshrc for testing\n")
    os.environ["ZSHRC"] = os.path.abspath(".zshrc")
    log(f"Mock .zshrc path: {os.getenv('ZSHRC')}")

    # Backup the actual .zshrc to simulate it not being found
    if os.path.exists(os.path.expanduser("~/.zshrc")):
        shutil.move(os.path.expanduser("~/.zshrc"), os.path.expanduser("~/.zshrc.bak"))
    if os.path.exists(os.path.expanduser("~/.config/zsh/.zshrc")):
        shutil.move(
            os.path.expanduser("~/.config/zsh/.zshrc"),
            os.path.expanduser("~/.config/zsh/.zshrc.bak"),
        )
    if os.path.exists(os.path.expanduser("~/.zprofile")):
        shutil.move(
            os.path.expanduser("~/.zprofile"), os.path.expanduser("~/.zprofile.bak")
        )

    log("Test environment setup complete.")
    yield

    # Teardown: Restore the original .zshrc and cleanup
    log("Tearing down test environment...")
    if os.path.exists(os.path.expanduser("~/.zshrc.bak")):
        shutil.move(os.path.expanduser("~/.zshrc.bak"), os.path.expanduser("~/.zshrc"))
    if os.path.exists(os.path.expanduser("~/.config/zsh/.zshrc.bak")):
        shutil.move(
            os.path.expanduser("~/.config/zsh/.zshrc.bak"),
            os.path.expanduser("~/.config/zsh/.zshrc"),
        )
    if os.path.exists(os.path.expanduser("~/.zprofile.bak")):
        shutil.move(
            os.path.expanduser("~/.zprofile.bak"), os.path.expanduser("~/.zprofile")
        )

    os.chdir("..")
    shutil.rmtree(test_dir)
    log("Test environment teardown complete.")
