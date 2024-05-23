import os
import shutil
import subprocess
import pytest
import time

def log(message):
    print(f"[{time.strftime('%Y-%m-%d %H:%M:%S')}] {message}")

@pytest.fixture(scope="module")
def setup_and_teardown():
    # Setup: Prepare test environment
    log("Setting up test environment...")

    # Get the absolute path to the project root
    project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
    log(f"Project root: {project_root}")

    # Run the uninstall script
    uninstall_script = os.path.join(project_root, "scripts", "uninstall.sh")
    if os.path.exists(uninstall_script):
        subprocess.run([uninstall_script], check=True)
    else:
        log(f"Uninstall script not found at {uninstall_script}")

    # Create a clean test directory for testing
    test_dir = "./test_hyperdirmic"
    if os.path.exists(test_dir):
        shutil.rmtree(test_dir)
    os.makedirs(test_dir)

    # Copy necessary files to the test directory
    files_to_copy = [
        "scripts/install.sh",
        "scripts/uninstall.sh",
        "scripts/run.sh",
        "scripts/test_install.sh",
        "scripts/test_uninstall.sh"
    ]
    for file in files_to_copy:
        dest_file = os.path.join(test_dir, file)
        os.makedirs(os.path.dirname(dest_file), exist_ok=True)
        shutil.copy(file, dest_file)
        log(f"Copied {file} to {dest_file}")

    # Copy the src directory
    shutil.copytree(os.path.join(project_root, "src"), os.path.join(test_dir, "src"))

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
