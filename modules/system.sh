#!/bin/bash

source "$(dirname "${BASH_SOURCE[0]}")/../lib/tui.sh"
source "$(dirname "${BASH_SOURCE[0]}")/../lib/distro.sh"

perform_update() {
    clear
    show_banner "System Updater"
    
    local tmp_log
    tmp_log=$(mktemp /tmp/gt-update.XXXXXX)
    
    run_with_spinner "$SYS_UPDATE >\"$tmp_log\" 2>&1" "Updating System" "$tmp_log"
    
    if [ -f "$tmp_log" ]; then
        echo
        tail -n 20 "$tmp_log"
        rm -f "$tmp_log"
    fi
    
    alert_success "System update completed."
    pause
}
