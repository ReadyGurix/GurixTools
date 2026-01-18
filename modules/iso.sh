#!/bin/bash

source "$(dirname "${BASH_SOURCE[0]}")/../lib/tui.sh"

download_iso() {
    local iso_name="$1"
    local download_dir="$HOME/Downloads"
    mkdir -p "$download_dir"

    declare -A iso_sources=(
        ["ubuntu24"]="https://releases.ubuntu.com/noble/ubuntu-24.04.2-desktop-amd64.iso"
        ["ubuntu25"]="https://releases.ubuntu.com/25.04/ubuntu-25.04-desktop-amd64.iso"
        ["ubuntu-server24"]="https://releases.ubuntu.com/noble/ubuntu-24.04.2-live-server-amd64.iso"
        ["debian"]="https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-12.11.0-amd64-netinst.iso"
        ["kali"]="https://cdimage.kali.org/kali-2025.2/kali-linux-2025.2-installer-amd64.iso"
        ["fedora"]="https://download.fedoraproject.org/pub/fedora/linux/releases/39/Workstation/x86_64/iso/Fedora-Workstation-Live-x86_64-39-1.5.iso"
        ["arch"]="https://geo.mirror.pkgbuild.com/iso/latest/archlinux-x86_64.iso"
        ["mint"]="https://mirrors.edge.kernel.org/linuxmint/stable/21.2/linuxmint-21.2-cinnamon-64bit.iso"
        ["windows"]="https://software.download.prss.microsoft.com/dbazure/Win11_24H2_English_x64.iso"
        ["centos"]="https://mirrors.centos.org/mirrorlist?path=/10-stream/BaseOS/x86_64/iso/CentOS-Stream-10-latest-x86_64-dvd1.iso&redirect=1&protocol=https"
    )

    if [ "$iso_name" = "list" ] || [ -z "$iso_name" ]; then
        clear
        show_banner "ISO Downloader"
        echo -e "${COLOR_INFO}Available ISOs:${COLOR_RESET}"
        echo -e "  ${COLOR_SUCCESS}[1]${COLOR_RESET} Ubuntu 24.04 LTS"
        echo -e "  ${COLOR_SUCCESS}[2]${COLOR_RESET} Ubuntu 25.04"
        echo -e "  ${COLOR_SUCCESS}[3]${COLOR_RESET} Debian 12"
        echo -e "  ${COLOR_SUCCESS}[4]${COLOR_RESET} Kali Linux"
        echo -e "  ${COLOR_SUCCESS}[5]${COLOR_RESET} Fedora 39"
        echo -e "  ${COLOR_SUCCESS}[6]${COLOR_RESET} Arch Linux"
        echo -e "  ${COLOR_SUCCESS}[7]${COLOR_RESET} Linux Mint"
        echo -e "  ${COLOR_SUCCESS}[8]${COLOR_RESET} Windows 11"
        echo -e "  ${COLOR_SUCCESS}[9]${COLOR_RESET} CentOS Stream 10"
        echo -e "  ${COLOR_WARNING}[10]${COLOR_RESET} Server ISOs"
        echo -e "  ${COLOR_ERROR}[0]${COLOR_RESET} Exit"
        echo
        read -p "Select an option: " option

        case $option in
            1) iso_name="ubuntu24" ;;
            2) iso_name="ubuntu25" ;;
            3) iso_name="debian" ;;
            4) iso_name="kali" ;;
            5) iso_name="fedora" ;;
            6) iso_name="arch" ;;
            7) iso_name="mint" ;;
            8) iso_name="windows" ;;
            9) iso_name="centos" ;;
            10)
                echo -e "\n${COLOR_WARNING}Server ISOs:${COLOR_RESET}"
                echo -e "  ${COLOR_SUCCESS}[1]${COLOR_RESET} Ubuntu Server 24.04"
                echo -e "  ${COLOR_ERROR}[0]${COLOR_RESET} Back"
                read -p "Select: " s_opt
                case $s_opt in
                    1) iso_name="ubuntu-server24" ;;
                    *) return ;;
                esac
                ;;
            0) return ;;
            *) alert_error "Invalid option"; return ;;
        esac
    fi

    if [ -n "${iso_sources[$iso_name]}" ]; then
        local url="${iso_sources[$iso_name]}"
        echo -e "Downloading ${COLOR_PRIMARY}$iso_name${COLOR_RESET}..."
        wget -c "$url" -P "$download_dir"
        alert_success "Download complete: $download_dir"
    else
        alert_error "ISO '$iso_name' not found."
    fi
}
