#!/bin/bash

# Language Management Library

CONFIG_DIR="/etc/gurixtools"
CONFIG_FILE="$CONFIG_DIR/config"
LANG_DIR="/usr/local/lib/gurixtools/lang"

# Function to detect system language
detect_language() {
    local sys_lang=$(echo $LANG | cut -d. -f1)
    # Default to en_US if detection fails or not supported
    case "$sys_lang" in
        es_ES|es_*)
            echo "es_ES"
            ;;
        ca_ES|ca_*)
            echo "ca_ES"
            ;;
        *)
            echo "en_US"
            ;;
    esac
}

# Function to load language file
load_language() {
    local lang_code="$1"
    local lang_file=""
    
    # If running from source/dev
    if [ -f "$(dirname "${BASH_SOURCE[0]}")/../lang/${lang_code}.sh" ]; then
        lang_file="$(dirname "${BASH_SOURCE[0]}")/../lang/${lang_code}.sh"
    # If installed
    elif [ -f "$LANG_DIR/${lang_code}.sh" ]; then
        lang_file="$LANG_DIR/${lang_code}.sh"
    else
        # Fallback to English
        if [ -f "$(dirname "${BASH_SOURCE[0]}")/../lang/en_US.sh" ]; then
             lang_file="$(dirname "${BASH_SOURCE[0]}")/../lang/en_US.sh"
        elif [ -f "$LANG_DIR/en_US.sh" ]; then
             lang_file="$LANG_DIR/en_US.sh"
        fi
    fi
    
    if [ -n "$lang_file" ] && [ -f "$lang_file" ]; then
        source "$lang_file"
    fi
}

# Function to get configured language
get_configured_language() {
    if [ -f "$CONFIG_FILE" ]; then
        source "$CONFIG_FILE"
        echo "$GT_LANG"
    else
        detect_language
    fi
}

# Function to save language preference
save_language_preference() {
    local lang_code="$1"
    sudo mkdir -p "$CONFIG_DIR"
    echo "GT_LANG=\"$lang_code\"" | sudo tee "$CONFIG_FILE" > /dev/null
}
