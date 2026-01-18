#!/bin/bash

# Gurix Tools Installer

set -e

INSTALL_DIR="/usr/local/lib/gurixtools"
BIN_DIR="/usr/local/bin"

# Source language library
if [ -f "lib/lang.sh" ]; then
    source "lib/lang.sh"
else
    echo "Error: lib/lang.sh not found."
    exit 1
fi

# Language Selection Logic
DETECTED_LANG=$(detect_language)
load_language "$DETECTED_LANG"

echo "$MSG_LANG_DETECTED: $DETECTED_LANG"
echo "$MSG_USING_LANG: $DETECTED_LANG"
echo

# Optional: Allow user to change language
# For now, we'll just stick with detected or default to English if unknown.
# If we want to force a menu, we can do it here.
# But per request "auto detect... If not, make the user be able to choose", 
# auto-detection is the priority.
# However, to be "eligible by the user", we might want a prompt.
# Let's add a timeout prompt.

read -t 5 -p "Press ENTER to continue with $DETECTED_LANG or type 'select' to choose language: " choice || true
echo

if [[ "$choice" == "select" ]]; then
    echo "$MSG_SELECT_LANG"
    echo "1) English (US)"
    echo "2) Español (ES)"
    echo "3) Català (ES)"
    read -p "#? " lang_choice
    case $lang_choice in
        1) DETECTED_LANG="en_US";;
        2) DETECTED_LANG="es_ES";;
        3) DETECTED_LANG="ca_ES";;
        *) echo "Invalid choice, using/Opcion invalida, usando/Opció invàlida, usant: $DETECTED_LANG";;
    esac
    load_language "$DETECTED_LANG"
fi

echo "$MSG_INSTALLING"

# Detect Distro for dependencies
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$ID
else
    DISTRO="unknown"
fi

echo "$MSG_DETECTED_DISTRO: $DISTRO"

# Install Dependencies
echo "$MSG_INSTALLING_DEPS"
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
        echo "$MSG_WARN_DEPS $DISTRO."
        echo "$MSG_ENSURE_DEPS"
        ;;
esac

# Create directories
echo "$MSG_CREATING_DIRS"
sudo mkdir -p "$INSTALL_DIR/lib"
sudo mkdir -p "$INSTALL_DIR/modules"
sudo mkdir -p "$INSTALL_DIR/lang"

# Copy files
echo "$MSG_COPYING_FILES"
sudo cp lib/*.sh "$INSTALL_DIR/lib/"
sudo cp modules/*.sh "$INSTALL_DIR/modules/"
sudo cp lang/*.sh "$INSTALL_DIR/lang/"
sudo cp bin/gt "$INSTALL_DIR/gt"

# Save language preference
save_language_preference "$DETECTED_LANG"

# Set permissions
sudo chmod +x "$INSTALL_DIR/gt"

# Link binary
echo "$MSG_LINKING_BINARY"
sudo ln -sf "$INSTALL_DIR/gt" "$BIN_DIR/gt"

echo "$MSG_INSTALL_COMPLETE"
