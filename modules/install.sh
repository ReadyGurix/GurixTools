#!/bin/bash

source "$(dirname "${BASH_SOURCE[0]}")/../lib/tui.sh"
source "$(dirname "${BASH_SOURCE[0]}")/../lib/distro.sh"

install_package() {
    local package="$1"
    if [ -z "$package" ]; then
        alert_error "$MSG_ERR_NO_PKG"
        echo "$MSG_USAGE_INSTALL"
        exit 1
    fi

    echo
    read -p "$MSG_CONFIRM_INSTALL $package? [Y/n] " resp
    if [[ "$resp" =~ ^[Yy]$ || -z "$resp" ]]; then
        run_with_spinner "$PKG_INSTALL \"$package\"" "$MSG_INSTALLING_PKG $package"
    else
        echo "$MSG_CANCELLED"
    fi
}

remove_package() {
    local package="$1"
    if [ -z "$package" ]; then
        alert_error "$MSG_ERR_NO_PKG"
        echo "$MSG_USAGE_REMOVE"
        exit 1
    fi

    echo
    read -p "$MSG_CONFIRM_REMOVE $package? [Y/n] " resp
    if [[ "$resp" =~ ^[Yy]$ || -z "$resp" ]]; then
        run_with_spinner "$PKG_REMOVE \"$package\"" "$MSG_REMOVING_PKG $package"
    else
        echo "$MSG_CANCELLED"
    fi
}
