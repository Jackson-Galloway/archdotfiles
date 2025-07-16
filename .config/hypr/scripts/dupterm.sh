#!/bin/bash

# Script to open a new terminal in the same working directory as the active one.
#
# DEPENDENCIES:
# - jq: A command-line JSON processor. Install with 'sudo pacman -S jq' or 'sudo apt install jq'.
# - Your terminal emulator (e.g., alacritty, kitty, wezterm).

# --- CONFIGURATION ---
# Change this to your preferred terminal command.
# Examples:
# TERMINAL_CMD="kitty --directory"
# TERMINAL_CMD="wezterm cli spawn --cwd"
TERMINAL_CMD="kitty --directory"

# --- SCRIPT LOGIC ---
# Get the Process ID (PID) of the active window from hyprctl in JSON format.
ACTIVE_PID=$(hyprctl activewindow -j | jq -r '.pid')

# Check if a valid PID was found. If not, the active window is likely not a terminal.
if [ -z "$ACTIVE_PID" ] || [ "$ACTIVE_PID" == "null" ]; then
    # Fallback: Open a new terminal in the home directory.
    # We just run the first part of the command (e.g., 'alacritty').
    ${TERMINAL_CMD%% *} &
    exit 0
fi

# Find the current working directory (CWD) of the process with that PID.
# /proc/$PID/cwd is a symlink to the process's working directory.
CWD=$(readlink -f /proc/$ACTIVE_PID/cwd)

# Check if we successfully found a CWD.
if [ -z "$CWD" ]; then
    # Fallback: Open a new terminal in the home directory if CWD is not found.
    ${TERMINAL_CMD%% *} &
    exit 0
fi

# Launch the new terminal in the found directory.
$TERMINAL_CMD "$CWD" &

exit 0

