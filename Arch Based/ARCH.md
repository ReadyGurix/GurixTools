# Bash Script Adaptation for Arch Linux - Changes Summary

## Overview
The `gt` (Gurix Tools) bash script has been adapted for Arch Linux with the addition of:
- A modular loading bar function for better UX during long-running operations
- Customizable color variables for easy theme modification
- Loading bars that stick to the bottom of the terminal

## Key Changes

### 1. **Color Variables Section** (NEW)
A dedicated color configuration section at the beginning makes the script easily themeable:

```bash
COLOR_PRIMARY="\e[1;36m"      # Bright Cyan - Primary text
COLOR_SUCCESS="\e[1;32m"      # Bright Green - Success messages
COLOR_ERROR="\e[1;31m"        # Bright Red - Error messages
COLOR_WARNING="\e[1;33m"      # Bright Yellow - Warning messages
COLOR_INFO="\e[1;34m"         # Bright Blue - Information boxes
COLOR_ACCENT="\e[37m"         # White - Accent text
COLOR_RESET="\e[0m"           # Reset to default
```

**Benefits:**
- Change all colors in one place
- No need to hunt through the code for color codes
- Easy to create different themes by modifying this section

### 2. **Bottom-Sticking Loading Bar** (UPDATED)

#### `show_loading_bar()`
- **Purpose**: Displays an animated loading spinner while a background process runs
- **Usage**: `long_running_command & show_loading_bar $! "Operation description"`
- **Features**:
  - ✨ **NEW**: Stays at the bottom of the terminal (doesn't interfere with content)
  - ✨ **NEW**: Uses customizable color variables
  - Shows animated Braille spinner characters (⠋ ⠙ ⠹ etc.)
  - Displays custom message with color coding
  - Waits for process completion
  - Shows ✓ (green) on success or ✗ (red) on failure
  - Returns the exit code of the process
  - Saves and restores cursor position

#### `show_loading_bar_simple()`
- **Purpose**: Displays a loading spinner for a fixed duration
- **Usage**: `show_loading_bar_simple "Operation description" [duration]`
- **Features**:
  - ✨ **NEW**: Stays at the bottom of the terminal
  - ✨ **NEW**: Uses customizable color variables
  - Uses same animated spinner
  - Runs for specified duration (default: 3 seconds)
  - Shows ✓ (green) checkmark at completion
  - Useful when duration is unpredictable

### 3. **Version Flag with Color Examples** (NEW)
Running `gt -v` or `gt --version` now shows:
- Script version and distribution information
- **Live color examples** showing all available colors
- Easy reference for developers using the color variables

Example output:
```
Gurix Tools versió 1.5.1

Versió per la distribució Arch

Desenvolupat per Gurix

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Example with SUCCESS color (green)
Example with ERROR color (red)
Example with WARNING color (yellow)
Example with PRIMARY color (cyan)
Example with INFO color (blue)
Example with ACCENT color (white)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 4. **Package Manager Changes (APT → PACMAN)**

#### `install()` function
- **Before**: `yay -Syu "$package" --noconfirm`
- **After**: `yay -S "$package" --noconfirm &` with loading bar
- **Note**: Removed the `-u` (update) flag from yay to only install specified package
- Now uses `show_loading_bar` to display progress at the bottom

#### `uninstall()` function
- **Before**: `sudo apt purge "$package" -y`
- **After**: `sudo pacman -R "$package" --noconfirm &` with loading bar
- Uses Arch Linux's `pacman` package manager
- Now uses `show_loading_bar` to display progress at the bottom

#### `perform_update()` function
- **Before**: `yay -Syu --noconfirm` (no feedback)
- **After**: `yay -Syu --noconfirm &` with `show_loading_bar`
- Displays loading animation at the bottom during system update
- Updated to use color variables for consistent styling

### 5. **Installation Instructions Updates**

#### `unzip()` function
- **RAR support**:
  - **Before**: `sudo apt install unrar`
  - **After**: `sudo pacman -S unrar`
  
- **7z support**:
  - **Before**: `sudo apt install p7zip-full`
  - **After**: `sudo pacman -S p7zip`

#### `help()` function
- Updated help text to indicate "(via yay)" for install option
- Makes it clear to users that the script uses yay as the package manager

### 6. **UI/UX Updates**
- All boxes and dialogs now use color variables consistently
- ISO menu uses the new color scheme
- All "Sortint..." (Exiting...) messages updated with colors
- Entire script uses consistent color styling

## Loading Bar Implementation Examples

### Using with Install Function
```bash
yay -S firefox --noconfirm &
show_loading_bar $! "Instal·lant firefox"
```

### Using with Update Function
```bash
yay -Syu --noconfirm &
show_loading_bar $! "Actualitzant sistema"
```

### Using with Other Operations
```bash
# For a backup operation
tar -czf backup.tar.gz /home/user/important &
show_loading_bar $! "Creant còpia de seguretat"

# For a simple fixed-duration operation
show_loading_bar_simple "Processant fitxers" 5
```

## How to Customize Colors

Simply modify the color variables at the beginning of the script:

```bash
# Change PRIMARY to a different bright color
COLOR_PRIMARY="\e[1;35m"      # Change to Bright Magenta instead

# Or use standard colors
# \e[1;30m = Bright Black
# \e[1;34m = Bright Blue
# \e[1;35m = Bright Magenta
# \e[1;36m = Bright Cyan (default)
# \e[1;37m = Bright White
```

## Benefits

1. **Better UX**: 
   - Users see immediate feedback during long operations
   - Loading bar doesn't interfere with content
   - Stays visually separate at the bottom of screen

2. **Easy Customization**: 
   - Change colors in one place
   - Easily create different themes
   - Live examples in version command

3. **Modularity**: 
   - Loading bar functions can be reused in other functions
   - Color variables can be extended for new colors

4. **Arch Compatibility**: 
   - All package manager commands use `pacman`/`yay`

5. **Visual Feedback**: 
   - Color-coded results (green for success, red for failure)
   - Consistent styling throughout the script

## Compilation for Arch Linux

To compile this script using `shc`:
```bash
shc -f ~/apps/gt/gt && sudo mv ~/apps/gt/gt.x /usr/local/bin/gt && sudo chmod +x /usr/local/bin/gt && rm ~/apps/gt/gt.x.c
```

## Technical Details

### Loading Bar Positioning
The loading bar uses `tput` commands to position itself:
- `tput sc` - Save cursor position
- `tput cup $((term_height - 1)) 0` - Move to bottom line
- `tput rc` - Restore cursor position
- `tput el` - Clear to end of line

This ensures the bar doesn't interfere with script output above it.

## Notes

- The script maintains all original functionality
- All Catalan language strings are preserved
- The loading bar uses ANSI escape codes for colors and animation
- The script requires `bc` command for time calculations in `show_loading_bar_simple()`
- Compatible with standard Arch Linux systems with `yay` installed
- Loading bars are POSIX-compatible with standard terminal utilities

## Version
- **Version**: 1.5.1
- **Target Distribution**: Arch Linux
- **Last Updated**: 2025-11-12
