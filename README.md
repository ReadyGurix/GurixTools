# Gurix Tools

A modular, multi-distro CLI toolkit for Linux power-users. Simplifies package management, system updates, ISO downloads, and more with a modern TUI.

![gt version](https://img.shields.io/badge/version-2.1.0b-blue.svg)

## Index

- [Installation](#installation)
- [Usage](#usage)
- [Modules](#modules)
- [Configuration](#configuration)
- [Contributing](#contributing)
- [License](#license)

## Configuration

For details on how to configure language settings and manage the tool, please refer to [CONFIGURATION.md](CONFIGURATION.md).

## Dependencies

Gurix Tools requires the following packages to function correctly:

- `bash` (4.0+)
- `wget` (for downloading ISOs)
- `bc` (for calculations)
- `toilet` (for banners)
- `p7zip` / `unrar` (for archive extraction)

The installation script will attempt to install these automatically.

## How to Install

### Automatic Installation (Recommended)

Clone the repository and run the install script:

```bash
git clone https://github.com/ReadyGurix/GurixTools.git
cd GurixTools
./install.sh
```

This script detects your distribution (Arch, Debian/Ubuntu, Fedora) and installs the necessary dependencies and files.

### Manual Installation

1. Copy the library and module files to `/usr/local/lib/gurixtools`:
   ```bash
   sudo mkdir -p /usr/local/lib/gurixtools/{lib,modules}
   sudo cp lib/*.sh /usr/local/lib/gurixtools/lib/
   sudo cp modules/*.sh /usr/local/lib/gurixtools/modules/
   ```

2. Copy the executable and link it:
   ```bash
   sudo cp bin/gt /usr/local/lib/gurixtools/gt
   sudo chmod +x /usr/local/lib/gurixtools/gt
   sudo ln -sf /usr/local/lib/gurixtools/gt /usr/local/bin/gt
   ```

## Features

Gurix Tools provides a unified interface for common tasks across different distributions:

- **Package Management**: Install/Remove packages using `gt install` / `gt remove` (Supports `apt`, `pacman`/`yay`, `dnf`).
- **System Updates**: Update your system with `gt update`.
- **ISO Downloader**: Interactive menu to download popular Linux ISOs (`gt iso list`).
- **KVM Manager**: Easily start/stop KVM kernel modules (`gt kvm`).
- **File Utilities**:
  - `gt trash <file>`: Safely move files to trash.
  - `gt unzip <file>`: Extract various archive formats (zip, tar, rar, 7z).
  - `gt size <file>`: Check file/directory size.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
