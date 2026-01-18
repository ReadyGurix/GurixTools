#!/bin/bash

# Gurix Tools Installer

set -e

INSTALL_DIR="/usr/local/lib/gurixtools"
BIN_DIR="/usr/local/bin"

echo "Installing Gurix Tools..."

# Detect Distro for dependencies
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$ID
else
    DISTRO="unknown"
fi

echo "Detected Distro: $DISTRO"

# Install Dependencies
echo "Installing dependencies..."
case "$DISTRO" in
    arch|manjaro|endeavouros)
        if command -v yay &>/dev/null; then
            yay -S --noconfirm wget bc toilet p7zip unrar
        else
            sudo pacman -S --needed --noconfirm wget bc toilet p7zip unrar
        fi
        ;;
    debian|ubuntu|linuxmint|kali|pop)
        sudo apt update
        sudo apt install -y wget bc toilet p7zip-full unrar
        ;;
    fedora|rhel|centos)
        sudo dnf install -y wget bc toilet p7zip unrar
        ;;
    *)
        echo "Warning: Could not install dependencies automatically for $DISTRO."
        echo "Please ensure you have: wget, bc, toilet, p7zip, unrar"
        ;;
esac

# Create directories
echo "Creating directories..."
sudo mkdir -p "$INSTALL_DIR/lib"
sudo mkdir -p "$INSTALL_DIR/modules"

# Copy files
echo "Copying files..."
sudo cp lib/*.sh "$INSTALL_DIR/lib/"
sudo cp modules/*.sh "$INSTALL_DIR/modules/"
sudo cp bin/gt "$INSTALL_DIR/gt"

# Set permissions
sudo chmod +x "$INSTALL_DIR/gt"

# Link binary
echo "Linking binary..."
sudo ln -sf "$INSTALL_DIR/gt" "$BIN_DIR/gt"

echo "Installation complete! Run 'gt help' to get started."
