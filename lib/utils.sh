#!/bin/bash

# Utility functions

check_root() {
    if [ "$(id -u)" -ne 0 ]; then
        echo "Error: This command requires root privileges."
        exit 1
    fi
}

check_dependency() {
    local cmd="$1"
    if ! command -v "$cmd" &>/dev/null; then
        return 1
    fi
    return 0
}

ensure_dependency() {
    local cmd="$1"
    local pkg="${2:-$cmd}"
    if ! check_dependency "$cmd"; then
        echo "Error: Command '$cmd' not found. Please install '$pkg'."
        exit 1
    fi
}

# Pause function
pause() {
    read -n 1 -s -r -p "Press any key to continue..."
    echo
}
