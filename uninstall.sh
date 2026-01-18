#!/bin/bash

# Gurix Tools Uninstaller

set -e

INSTALL_DIR="/usr/local/lib/gurixtools"
BIN_LINK="/usr/local/bin/gt"

echo "Uninstalling Gurix Tools..."

if [ -L "$BIN_LINK" ]; then
    echo "Removing binary link..."
    sudo rm -f "$BIN_LINK"
fi

if [ -d "$INSTALL_DIR" ]; then
    echo "Removing installation directory..."
    sudo rm -rf "$INSTALL_DIR"
fi

echo "Uninstallation complete."
