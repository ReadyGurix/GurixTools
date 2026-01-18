#!/bin/bash

source "$(dirname "${BASH_SOURCE[0]}")/colors.sh"

# TUI Constants
LOADING_BAR_PADDING=3

# Spinner function
show_loading_bar() {
    local pid="$1"
    local message="${2:-Processing}"
    local logfile="$3"
    local delay=0.1
    local spinner=( '⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏' )
    local spinner_idx=0

    tput sc
    local term_height=$(tput lines)
    local bar_row=$((term_height - 1))
    local start_row=$((bar_row - LOADING_BAR_PADDING))
    
    if [ $start_row -lt 0 ]; then start_row=0; fi

    # Clear reserved area
    for ((r = start_row; r < bar_row; r++)); do
        tput cup $r 0
        tput el
    done

    while kill -0 "$pid" 2>/dev/null; do
        # Render log tail if provided
        if [ -n "$logfile" ] && [ -f "$logfile" ]; then
            mapfile -t _lines < <(tail -n "$LOADING_BAR_PADDING" "$logfile" 2>/dev/null)
            local idx=0
            for ((r = start_row; r < bar_row; r++)); do
                tput cup $r 0
                tput el
                if [ $idx -lt ${#_lines[@]} ]; then
                    printf "%s\n" "${_lines[$idx]}" | cut -c1-$(tput cols)
                fi
                idx=$((idx + 1))
            done
        fi

        tput cup $bar_row 0
        printf "${COLOR_PRIMARY}${message}${COLOR_RESET} ${spinner[$((spinner_idx++ % ${#spinner[@]}))]}"
        sleep "$delay"
    done

    wait "$pid"
    local exit_code=$?

    tput cup $((term_height - 1)) 0
    tput el
    
    if [ $exit_code -eq 0 ]; then
        printf "${COLOR_SUCCESS}✓ ${message}${COLOR_RESET}\n"
    else
        printf "${COLOR_ERROR}✗ ${message}${COLOR_RESET}\n"
    fi

    tput rc
    return $exit_code
}

run_with_spinner() {
    local cmd="$1"
    local message="$2"
    local logfile="$3"

    if [ "$(id -u)" -eq 0 ] || sudo -n true 2>/dev/null; then
        eval "$cmd" >"${logfile:-/dev/null}" 2>&1 &
        local pid=$!
        show_loading_bar "$pid" "$message" "$logfile"
        return $?
    else
        # Foreground if sudo prompt needed
        if [ -n "$logfile" ]; then
            eval "$cmd" >"$logfile" 2>&1
        else
            eval "$cmd"
        fi
        return $?
    fi
}

# Banner function
show_banner() {
    local title="$1"
    local term_width=$(tput cols)
    local box_width=40
    local padding=$(((term_width - box_width) / 2))
    local pad_str=$(printf '%*s' "$padding" '')

    echo -e "\n${pad_str}${COLOR_INFO}╭──────────────────────────────────────╮"
    printf "${pad_str}│${COLOR_PRIMARY}%*s%s%*s${COLOR_INFO}│\n" $(((box_width - 2 - ${#title}) / 2)) "" "$title" $(((box_width - 2 - ${#title} + 1) / 2)) ""
    echo -e "${pad_str}╰──────────────────────────────────────╯${COLOR_RESET}\n"
}

# Alert functions
alert_success() { echo -e "${COLOR_SUCCESS}✓ $1${COLOR_RESET}"; }
alert_error() { echo -e "${COLOR_ERROR}✗ $1${COLOR_RESET}"; }
alert_warning() { echo -e "${COLOR_WARNING}! $1${COLOR_RESET}"; }
alert_info() { echo -e "${COLOR_INFO}ℹ $1${COLOR_RESET}"; }
