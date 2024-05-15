import os
import subprocess
import unittest


class TestInstallation(unittest.TestCase):
    def setUp(self):
        # Set up any necessary resources or configurations for the test
        self.project_directory = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
        self.test_zshrc = self.find_zshrc()
        self.command_to_add = f"alias organize='source ./venv/bin/activate && PYTHONPATH=. python -m hyperdirmic.hyperdirmic'"

    def tearDown(self):
        # Clean up any resources created during the test (if needed)
        pass

    def find_zshrc(self):
        possible_locations = [
            os.path.expanduser("~/.zshrc"),
            os.path.expanduser("~/.config/zsh/.zshrc"),
            os.path.expanduser("~/.zprofile"),
        ]

        for location in possible_locations:
            if os.path.exists(location):
                return location

        return None


    def test_add_commands_to_zshrc(self):
        if not self.test_zshrc:
            self.fail("No .zshrc or .zprofile found.")

        # Navigate to the root directory of the project
        os.chdir(self.project_directory)

        # Call the installation script to add commands to .zshrc
        subprocess.run(["bash", "./install_hyperdirmic.sh"])

        # Read the modified .zshrc file and check if the command is added
        with open(self.test_zshrc, "r") as f:
            content = f.read()
            print("Content of .zshrc file:")
            print(content)

            print("Expected command:")
            print(self.command_to_add)

            self.assertIn(self.command_to_add, content)


if __name__ == "__main__":
    unittest.main()
