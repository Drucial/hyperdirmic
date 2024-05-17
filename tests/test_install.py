import os
import subprocess
import pytest
import shutil

def log(message):
    print(f"[{time.strftime('%Y-%m-%d %H:%M:%S')}] {message}")

@pytest.fixture(scope="module")
def setup_and_teardown():
    # Setup: Prepare test environment
    log("Setting up test environment...")
    subprocess.run(["../scripts/uninstall.sh"], check=True)

    # Create a clean clone of the repository for testing
    if os.path.exists("./test_hyperdirmic"):
        shutil.rmtree("./test_hyperdirmic")
    subprocess.run(["git", "clone", "..", "./test_hyperdirmic"], check=True)

    os.chdir("./test_hyperdirmic")

    # Create a mock .zshrc file in the test directory
    log("Creating mock .zshrc file...")
    with open(".zshrc", "w") as f:
        f.write("# Mock .zshrc for testing\n")
    os.environ["ZSHRC"] = os.path.abspath(".zshrc")

    # Backup the actual .zshrc to simulate it not being found
    if os.path.exists(os.path.expanduser("~/.zshrc")):
        shutil.move(os.path.expanduser("~/.zshrc"), os.path.expanduser("~/.zshrc.bak"))
    if os.path.exists(os.path.expanduser("~/.config/zsh/.zshrc")):
        shutil.move(os.path.expanduser("~/.config/zsh/.zshrc"), os.path.expanduser("~/.config/zsh/.zshrc.bak"))
    if os.path.exists(os.path.expanduser("~/.zprofile")):
        shutil.move(os.path.expanduser("~/.zprofile"), os.path.expanduser("~/.zprofile.bak"))

    log("Test environment setup complete.")
    yield

    # Teardown: Restore the original .zshrc and cleanup
    log("Tearing down test environment...")
    if os.path.exists(os.path.expanduser("~/.zshrc.bak")):
        shutil.move(os.path.expanduser("~/.zshrc.bak"), os.path.expanduser("~/.zshrc"))
    if os.path.exists(os.path.expanduser("~/.config/zsh/.zshrc.bak")):
        shutil.move(os.path.expanduser("~/.config/zsh/.zshrc.bak"), os.path.expanduser("~/.config/zsh/.zshrc"))
    if os.path.exists(os.path.expanduser("~/.zprofile.bak")):
        shutil.move(os.path.expanduser("~/.zprofile.bak"), os.path.expanduser("~/.zprofile"))

    os.chdir("..")
    shutil.rmtree("./test_hyperdirmic")
    log("Test environment teardown complete.")

def test_installation(setup_and_teardown):
    log("Running installation test...")

    # Run the installation script using expect to simulate user input
    install_script = '''
    spawn ./scripts/install.sh
    expect "Please specify the path to your zsh configuration file:"
    send -- "$env(ZSHRC)\r"
    expect eof
    '''
    with open("install.exp", "w") as f:
        f.write(install_script)
    subprocess.run(["expect", "install.exp"], check=True)

    # Verify virtual environment is created
    assert os.path.exists("venv"), "Failed to create virtual environment."

    # Verify launch agent is created
    assert os.path.exists(os.path.expanduser("~/Library/LaunchAgents/com.drucial.hyperdirmic.plist")), "Failed to create launch agent."

    # Verify utility commands are added to the mock .zshrc
    with open(os.getenv("ZSHRC"), "r") as f:
        content = f.read()
        assert "# Hyperdirmic utility commands" in content, "Failed to add utility commands to mock .zshrc."

    log("Installation test completed successfully.")

def test_uninstallation(setup_and_teardown):
    log("Running uninstallation test...")

    # Run the uninstallation script using expect to simulate user input
    uninstall_script = '''
    spawn ./scripts/uninstall.sh
    expect "Please specify the path to your zsh configuration file:"
    send -- "$env(ZSHRC)\r"
    expect eof
    '''
    with open("uninstall.exp", "w") as f:
        f.write(uninstall_script)
    subprocess.run(["expect", "uninstall.exp"], check=True)

    # Verify virtual environment is removed
    assert not os.path.exists("venv"), "Failed to remove virtual environment."

    # Verify launch agent is removed
    assert not os.path.exists(os.path.expanduser("~/Library/LaunchAgents/com.drucial.hyperdirmic.plist")), "Failed to remove launch agent."

    # Verify utility commands are removed from the mock .zshrc
    with open(os.getenv("ZSHRC"), "r") as f:
        content = f.read()
        assert "# Hyperdirmic utility commands" not in content, "Failed to remove utility commands from mock .zshrc."

    log("Uninstallation test completed successfully.")

if __name__ == "__main__":
    pytest.main()

