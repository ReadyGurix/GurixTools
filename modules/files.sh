#!/bin/bash

source "$(dirname "${BASH_SOURCE[0]}")/../lib/tui.sh"

trash_file() {
    local file="$1"
    if [ -z "$file" ]; then
        alert_error "No file specified."
        return 1
    fi

    if [ -f "$file" ] || [ -d "$file" ]; then
        mkdir -p ~/.local/share/Trash/files
        mv "$file" ~/.local/share/Trash/files/
        alert_success "Moved '$file' to trash."
    else
        alert_error "File '$file' not found."
    fi
}

unzip_file() {
    local file="$1"
    if [ -z "$file" ]; then
        alert_error "No file specified."
        return 1
    fi

    if [ ! -f "$file" ]; then
        alert_error "File '$file' not found."
        return 1
    fi

    local extension="${file##*.}"
    case "${extension,,}" in
        zip) unzip "$file" ;;
        tar) tar xf "$file" ;;
        gz|tgz) tar xzf "$file" ;;
        bz2) tar xjf "$file" ;;
        xz) tar xJf "$file" ;;
        rar)
            if command -v unrar &>/dev/null; then unrar x "$file"
            else alert_error "unrar not installed."; fi ;;
        7z)
            if command -v 7z &>/dev/null; then 7z x "$file"
            else alert_error "p7zip not installed."; fi ;;
        *) alert_error "Unsupported format: $extension" ;;
    esac
}

get_size() {
    local file="$1"
    if [ -z "$file" ]; then
        alert_error "No file specified."
        return 1
    fi

    if [ -e "$file" ]; then
        du -sh "$file"
    else
        alert_error "File '$file' not found."
    fi
}
