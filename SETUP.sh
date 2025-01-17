#!/bin/bash

cd hyprland-script-setup
cp -r rofi/ ~/.config && cp -r scripts/ ~/.config/hypr
chmod +x ~/.config/hypr/scripts/RofiEmoji.sh
chmod +x ~/.config/hypr/scripts/WallpaperSelect.sh
chmod +x ~/.config/hypr/scripts/rofi_app_menu.sh
mkdir ~/.config/hypr/wallpaper
cp test_for_wallpaper_script.png ~/.config/hypr/wallpaper
