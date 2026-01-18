#!/bin/bash

# Distro Detection and Abstraction

detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        DISTRO_ID=$ID
        DISTRO_NAME=$NAME
        DISTRO_VERSION=$VERSION_ID
    else
        DISTRO_ID="unknown"
        DISTRO_NAME="Unknown"
    fi
}

init_package_manager() {
    detect_distro
    
    case "$DISTRO_ID" in
        arch|manjaro|endeavouros)
            if command -v yay &>/dev/null; then
                PKG_INSTALL="yay -S --noconfirm"
                PKG_REMOVE="yay -R --noconfirm"
                SYS_UPDATE="yay -Syu --noconfirm"
            elif command -v paru &>/dev/null; then
                PKG_INSTALL="paru -S --noconfirm"
                PKG_REMOVE="paru -R --noconfirm"
                SYS_UPDATE="paru -Syu --noconfirm"
            else
                PKG_INSTALL="sudo pacman -S --noconfirm"
                PKG_REMOVE="sudo pacman -R --noconfirm"
                SYS_UPDATE="sudo pacman -Syu --noconfirm"
            fi
            ;;
        debian|ubuntu|linuxmint|kali|pop)
            PKG_INSTALL="sudo apt install -y"
            PKG_REMOVE="sudo apt remove -y"
            SYS_UPDATE="sudo apt update && sudo apt upgrade -y"
            ;;
        fedora|rhel|centos)
            PKG_INSTALL="sudo dnf install -y"
            PKG_REMOVE="sudo dnf remove -y"
            SYS_UPDATE="sudo dnf update -y"
            ;;
        *)
            echo "$MSG_WARN_UNSUPPORTED_DISTRO '$DISTRO_ID'. Package management commands may fail."
            PKG_INSTALL="echo '$MSG_ERR_INSTALL_NOT_SUPPORTED'"
            PKG_REMOVE="echo '$MSG_ERR_REMOVE_NOT_SUPPORTED'"
            SYS_UPDATE="echo '$MSG_ERR_UPDATE_NOT_SUPPORTED'"
            ;;
    esac
}

# Initialize on source
init_package_manager
