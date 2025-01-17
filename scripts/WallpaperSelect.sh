#!/bin/bash
# Path to your wallpaper directory
WALLPAPER_DIR="$HOME/.config/hypr/wallpaper/"
CURRENT_WALLPAPER="$HOME/.config/hypr/current_wallpaper.jpg"

# Check if Rofi is already running
if pgrep -x "rofi" > /dev/null; then
    # If Rofi is running, kill it
    pkill -x "rofi"

else
# Check if the wallpaper directory exists
if [[ ! -d "$WALLPAPER_DIR" ]]; then
    echo "Wallpaper directory does not exist: $WALLPAPER_DIR"
    exit 1
fi

# Retrieve image files using null delimiter to handle spaces in filenames
mapfile -d '' PICS < <(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) -print0)

# Check if any images were found
if [[ ${#PICS[@]} -eq 0 ]]; then
    echo "No wallpaper images found in $WALLPAPER_DIR."
    exit 1
fi

# Sort the PICS array by file name
IFS=$'\n' sorted_pics=($(sort <<<"${PICS[*]}"))
unset IFS

# Check if swww-daemon is running; if not, start it
if ! pgrep -x "swww-daemon" > /dev/null; then
    echo "Starting swww-daemon..."
    swww-daemon &
    sleep 1  # Wait for the daemon to initialize
fi

# Rofi command
rofi_command='rofi -config ~/.config/rofi/config_wallpaper.rasi -dmenu -i -p 🖼️'

# Function to display the menu with images as icons
menu() {
    for pic_path in "${sorted_pics[@]}"; do
        pic_name=$(basename "$pic_path")
        printf "%s\x00icon\x1f%s\n" "$pic_name" "$pic_path"
    done
}

main() {
    choice=$(menu | $rofi_command)

    # Check if a choice was made
    if [[ -z "$choice" ]]; then
        echo "No wallpaper selected. Exiting."
        exit 0
    fi

    # Ensure the full path is used
    for pic_path in "${sorted_pics[@]}"; do
        if [[ "$(basename "$pic_path")" == "$choice" ]]; then
            FULL_WALLPAPER_PATH="$pic_path"
            break
        fi
    done

    # Set the selected wallpaper using swww
    echo "Setting wallpaper to: $FULL_WALLPAPER_PATH"
    if swww img "$FULL_WALLPAPER_PATH" --transition-fps 60 --transition-type any --transition-duration 3; then
        # Copy the selected wallpaper to the current wallpaper file
        cp "$FULL_WALLPAPER_PATH" "$CURRENT_WALLPAPER"
        echo "Current wallpaper saved to: $CURRENT_WALLPAPER"

        # Generate colors from the current wallpaper
        generate_colors
    else
        echo "Failed to set wallpaper."
    fi
}
    # symlink the wallpaper to the location Rofi can access
    if ln -sf "$wallpaper_path" "$HOME/.config/rofi/.current_wallpaper"; then
        ln_success=true  # Set the flag to true upon successful execution
    fi
    # copy the wallpaper for wallpaper effects
	cp -r "$wallpaper_path" "~/.config/hypr/current_wallpaper.jpg"


# Execute the main function
main
pkill waybar
waybar &
wal -c
wal -q -i ~/.config/hypr/current_wallpaper.jpg
cp ~/.cache/wal/schemes/_home_spacexd__config_hypr_current_wallpaper_jpg_dark_None_None_1.1.0.json ~/.config/hypr
~/.config/hypr/scripts/pywal-obsidian/pywal-obsidianmd.sh
fi
