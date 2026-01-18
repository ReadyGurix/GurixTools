#!/bin/bash

source "$(dirname "${BASH_SOURCE[0]}")/../lib/tui.sh"

trash_file() {
    local file="$1"
    if [ -z "$file" ]; then
        alert_error "$MSG_ERR_NO_FILE"
        return 1
    fi

    if [ -f "$file" ] || [ -d "$file" ]; then
        mkdir -p ~/.local/share/Trash/files
        mv "$file" ~/.local/share/Trash/files/
        alert_success "$MSG_FILE_MOVED_TRASH '$file'"
    else
        alert_error "$MSG_ERR_FILE_NOT_FOUND '$file'"
    fi
}

unzip_file() {
    local file="$1"
    if [ -z "$file" ]; then
        alert_error "$MSG_ERR_NO_FILE"
        return 1
    fi

    if [ ! -f "$file" ]; then
        alert_error "$MSG_ERR_FILE_NOT_FOUND '$file'"
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
            else alert_error "$MSG_ERR_UNRAR_NOT_INSTALLED"; fi ;;
        7z)
            if command -v 7z &>/dev/null; then 7z x "$file"
            else alert_error "$MSG_ERR_7Z_NOT_INSTALLED"; fi ;;
        *) alert_error "$MSG_ERR_UNSUPPORTED_FORMAT $extension" ;;
    esac
}

get_size() {
    local file="$1"
    if [ -z "$file" ]; then
        alert_error "$MSG_ERR_NO_FILE"
        return 1
    fi

    if [ -e "$file" ]; then
        du -sh "$file"
    else
        alert_error "$MSG_ERR_FILE_NOT_FOUND '$file'"
    fi
}
