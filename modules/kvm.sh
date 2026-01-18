#!/bin/bash

source "$(dirname "${BASH_SOURCE[0]}")/../lib/tui.sh"

kvm_manager() {
    clear
    show_banner "$MSG_KVM_BANNER"

    if lsmod | grep -q kvm; then
        echo -e "$MSG_KVM_STATUS${COLOR_SUCCESS}$MSG_KVM_ACTIVE${COLOR_RESET}"
        read -p "$MSG_KVM_STOP_PROMPT" resp
        if [[ "$resp" =~ ^[Yy]$ || -z "$resp" ]]; then
            sudo rmmod kvm_amd kvm_intel kvm 2>/dev/null
            alert_success "$MSG_KVM_STOPPED"
        fi
    else
        echo -e "$MSG_KVM_STATUS${COLOR_ERROR}$MSG_KVM_INACTIVE${COLOR_RESET}"
        read -p "$MSG_KVM_START_PROMPT" resp
        if [[ "$resp" =~ ^[Yy]$ || -z "$resp" ]]; then
            sudo modprobe kvm
            # Try both intel and amd, suppress errors if one fails
            sudo modprobe kvm_amd 2>/dev/null
            sudo modprobe kvm_intel 2>/dev/null
            alert_success "$MSG_KVM_STARTED"
        fi
    fi
    pause
}
