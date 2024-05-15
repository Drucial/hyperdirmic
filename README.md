
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
./install_hyperdirmic.sh
```

This will set up the virtual environment, install necessary dependencies, configure the launch agent, and add utility commands to your `.zshrc`.

## Uninstallation

To uninstall Hyperdirmic, follow these steps:

1. **Run the Uninstall Script**:
```bash
./uninstall_hyperdirmic.sh
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

## Troubleshooting

If you encounter any issues, please check the logs using the `loghyperdirmic` and `errorhyperdirmic` commands.

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
