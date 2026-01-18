#!/bin/bash

source "$(dirname "${BASH_SOURCE[0]}")/../lib/tui.sh"

kvm_manager() {
    clear
    show_banner "KVM Manager"

    if lsmod | grep -q kvm; then
        echo -e "Status: ${COLOR_SUCCESS}Active${COLOR_RESET}"
        read -p "Stop KVM? [Y/n] " resp
        if [[ "$resp" =~ ^[Yy]$ || -z "$resp" ]]; then
            sudo rmmod kvm_amd kvm_intel kvm 2>/dev/null
            alert_success "KVM stopped."
        fi
    else
        echo -e "Status: ${COLOR_ERROR}Inactive${COLOR_RESET}"
        read -p "Start KVM? [Y/n] " resp
        if [[ "$resp" =~ ^[Yy]$ || -z "$resp" ]]; then
            sudo modprobe kvm
            # Try both intel and amd, suppress errors if one fails
            sudo modprobe kvm_amd 2>/dev/null
            sudo modprobe kvm_intel 2>/dev/null
            alert_success "KVM started."
        fi
    fi
    pause
}
