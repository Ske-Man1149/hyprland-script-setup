#!/bin/bash

# Check if Rofi is already running
if pgrep -x "rofi" > /dev/null; then
    # If Rofi is running, kill it
    pkill -x "rofi"
else
    # If Rofi is not running, launch it with drun and icons
    rofi -show drun -show-icons &
fi
