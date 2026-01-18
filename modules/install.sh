#!/bin/bash

source "$(dirname "${BASH_SOURCE[0]}")/../lib/tui.sh"
source "$(dirname "${BASH_SOURCE[0]}")/../lib/distro.sh"

install_package() {
    local package="$1"
    if [ -z "$package" ]; then
        alert_error "No package specified."
        echo "Usage: gt install <package>"
        exit 1
    fi

    echo
    read -p "Do you want to install $package? [Y/n] " resp
    if [[ "$resp" =~ ^[Yy]$ || -z "$resp" ]]; then
        run_with_spinner "$PKG_INSTALL \"$package\"" "Installing $package"
    else
        echo "Cancelled."
    fi
}

remove_package() {
    local package="$1"
    if [ -z "$package" ]; then
        alert_error "No package specified."
        echo "Usage: gt remove <package>"
        exit 1
    fi

    echo
    read -p "Do you want to remove $package? [Y/n] " resp
    if [[ "$resp" =~ ^[Yy]$ || -z "$resp" ]]; then
        run_with_spinner "$PKG_REMOVE \"$package\"" "Removing $package"
    else
        echo "Cancelled."
    fi
}
