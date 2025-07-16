#!/bin/bash

# Lock the screen with hyprlock
hyprlock &

# Give hyprlock a moment to start before suspending
sleep 0.5

# Suspend the system
systemctl suspend
