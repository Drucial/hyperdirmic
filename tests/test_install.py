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

    # Run the uninstall script
    uninstall_script = os.path.join(project_root, "scripts", "uninstall.sh")
    if os.path.exists(uninstall_script):
        subprocess.run([uninstall_script], check=True)
    else:
        log(f"Uninstall script not found at {uninstall_script}")

    # Create a clean clone of the repository for testing
    if os.path.exists("./test_hyperdirmic"):
        shutil.rmtree("./test_hyperdirmic")
    subprocess.run(["git", "clone", ".", "./test_hyperdirmic"], check=True)

    # Ensure the scripts are copied correctly to the test_hyperdirmic directory
    os.makedirs("./test_hyperdirmic/scripts", exist_ok=True)
    shutil.copy(
        os.path.join(project_root, "scripts", "install.sh"),
        "./test_hyperdirmic/scripts/install.sh",
    )
    shutil.copy(
        os.path.join(project_root, "scripts", "uninstall.sh"),
        "./test_hyperdirmic/scripts/uninstall.sh",
    )

    os.chdir("./test_hyperdirmic")
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
    shutil.rmtree("./test_hyperdirmic")
    log("Test environment teardown complete.")


def test_installation(setup_and_teardown):
    log("Running installation test...")

    # Get the relative path to the install script within the test_hyperdirmic directory
    install_script_path = os.path.join("scripts", "install.sh")
    log(f"Install script path: {install_script_path}")

    # Run the installation script using expect to simulate user input
    install_script = f"""
    spawn {install_script_path}
    expect "Please specify the path to your zsh configuration file:"
    send -- "$env(ZSHRC)\r"
    expect eof
    """
    with open("install.exp", "w") as f:
        f.write(install_script)
    subprocess.run(["expect", "install.exp"], check=True)

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


def test_uninstallation(setup_and_teardown):
    log("Running uninstallation test...")

    # Get the relative path to the uninstall script within the test_hyperdirmic directory
    uninstall_script_path = os.path.join("scripts", "uninstall.sh")
    log(f"Uninstall script path: {uninstall_script_path}")

    # Run the uninstallation script using expect to simulate user input
    uninstall_script = f"""
    spawn {uninstall_script_path}
    expect "Please specify the path to your zsh configuration file:"
    send -- "$env(ZSHRC)\r"
    expect eof
    """
    with open("uninstall.exp", "w") as f:
        f.write(uninstall_script)
    subprocess.run(["expect", "uninstall.exp"], check=True)

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


if __name__ == "__main__":
    pytest.main()
