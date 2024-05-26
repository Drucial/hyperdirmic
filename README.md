# Hyperdirmic Script

## Overview

The Hyperdirmic script is designed to automatically organize files by type across designated directories such as Desktop and Downloads. It helps in maintaining cleanliness and order by automatically moving files into predefined folders based on their extensions.

## How It Works

The script utilizes the Python Watchdog library to monitor changes in specified directories and reacts to the creation of new files. Depending on the file extension, the script moves files to respective folders, such as TextFiles, Images, etc., within the Downloads directory.

## Getting Started

### Prerequisites

- Python 3.x
- pip
- git (for cloning the repository)

## Installation

To install Hyperdirmic, follow these steps:

1. **Clone the Repository**:

```bash
git clone https://github.com/Drucial/hyperdirmic.git
cd hyperdirmic
```

2. **Run the Install Script**:

```bash
./scripts/install.sh
```

This will set up the virtual environment, install necessary dependencies, configure the launch agent, and add utility commands to your `.zshrc`.

## Uninstallation

To uninstall Hyperdirmic, follow these steps:

1. **Run the Uninstall Script**:

```bash
./scripts/uninstall.sh
```

This will stop any running Hyperdirmic processes, remove the launch agent, delete the virtual environment, and remove utility commands from your `.zshrc`.

## Utility Commands

After installation, you can use the following utility commands:

- **To kill the running `hyperdirmic` process**:
  ```bash
  killhyperdirmic
  ```
- **To view the standard output log**:
  ```bash
  loghyperdirmic
  ```
- **To view the standard error log**:
  ```bash
  errorhyperdirmic
  ```
- **To view the debug log**:
  ```bash
  debughyperdirmic
  ```
- **To view all logs combined**:
  ```bash
  allhyperdirmiclogs
  ```

## Troubleshooting

If you encounter any issues, please check the logs using the `loghyperdirmic`, `errorhyperdirmic`, `debughyperdirmic`, and `allhyperdirmiclogs` commands.

## Development Environment Setup

1. **Create a virtual environment:**

   ```bash
   python3 -m venv venv
   ```

2. **Activate the virtual environment:**

   ```bash
   source venv/bin/activate
   ```

3. **Install dependencies:**

   ```bash
   pip install --upgrade pip
   pip install -r requirements.txt
   ```

4. **Running Tests:**

   ```bash
   ./scripts/test.sh
   ```

5. **Linting and Formatting:**

   ```bash
   ./scripts/lint.sh
   ./scripts/format.sh
   ```

### 5. Configure Git Hooks (Optional)

You can set up Git hooks to automatically run linting and tests before committing. Here’s an example using pre-commit:

1. **Install pre-commit**:

   ```bash
   pip install pre-commit
   ```

2. **Create a `.pre-commit-config.yaml` file**:

   ```yaml
   repos:
     - repo: https://github.com/pre-commit/mirrors-prettier
       rev: v2.3.0
       hooks:
         - id: prettier
     - repo: https://github.com/pre-commit/flake8
       rev: v3.9.2
       hooks:
         - id: flake8
     - repo: https://github.com/psf/black
       rev: 21.7b0
       hooks:
         - id: black
   ```

3. **Install the pre-commit hooks**:
   ```bash
   pre-commit install
   ```

### 6. Continuous Integration (CI)

Set up a CI pipeline to automate tests and linting. Here’s an example using GitHub Actions:

- **.github/workflows/ci.yml**:

  ```yaml
  name: CI

  on: [push, pull_request]

  jobs:
    test:
      runs-on: ubuntu-latest

      steps:
        - uses: actions/checkout@v2
        - name: Set up Python
          uses: actions/setup-python@v2
          with:
            python-version: "3.x"
        - name: Install dependencies
          run: |
            python -m venv venv
            source venv/bin/activate
            pip install --upgrade pip
            pip install -r requirements.txt
        - name: Run tests
          run: |
            source venv/bin/activate
            pytest
        - name: Lint code
          run: |
            source venv/bin/activate
            flake8 .
        - name: Format code
          run: |
            source venv/bin/activate
            black --check .
  ```

### Summary

By following these steps, you ensure a consistent and automated development environment setup. Your project structure should look like this:

## Conclusion

The Hyperdirmic script automates file organization tasks, making it easier to keep your desktop and downloads directory well-organized without manual intervention.

## Roadmap

- Add support for more file types and extensions.
- Implement a configuration file to customize the script's behavior.
- Add support for multiple directories and custom folder structures.
- Implement a GUI for easier configuration and monitoring.

## TODO

- [ ] Better Folder Icons
- [ ] Add more tests to ensure the script's reliability and stability.
- [ ] Implement a more robust error handling mechanism.
- [ ] Add support for logging and monitoring the script's activity.
- [ ] Add support for more file types and extensions.
- [ ] Implement a configuration file to customize the script's behavior.
- [ ] Add support for multiple directories and custom folder structures.
- [ ] Implement a GUI for easier configuration and monitoring.

<!-- For more details on custom configurations and advanced options, refer to the `Advanced_Configuration.md` in the repository. -->
