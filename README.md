
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

### Cloning the Repository
To get started with the Hyperdirmic script, clone the repository to your local machine:

```bash
git clone https://github.com/drucial/hyperdirmic.git
cd hyperdirmic
```

### Installation
Run the installation script to set up the necessary environment and dependencies:

```bash
./install_hyperdirmic.sh
```

This script sets up a Python virtual environment, installs necessary dependencies, and configures the script to run at system startup.

## Testing the Script
To ensure the script functions as intended, follow the comprehensive testing instructions provided in the repository:

1. **Functional Tests**: Verify file organization and error handling.
2. **Performance Monitoring**: Ensure the script does not consume excessive system resources.
3. **Automated Restart Tests**: Confirm that the script restarts correctly after system reboots.

Detailed testing steps can be found in the `Testing_Instructions.md` included in the repository.

## Conclusion
The Hyperdirmic script automates file organization tasks, making it easier to keep your desktop and downloads directory well-organized without manual intervention.

For more details on custom configurations and advanced options, refer to the `Advanced_Configuration.md` in the repository.
