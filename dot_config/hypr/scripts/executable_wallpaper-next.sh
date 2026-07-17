#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
STATE_FILE="/tmp/hyprpaper_index"

mapfile -d '' wallpapers < <(
    find "$WALLPAPER_DIR" -maxdepth 1 -type f \
    \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) \
    -print0 | sort -z
)

count=${#wallpapers[@]}

[[ $count -eq 0 ]] && exit 1

if [[ -f "$STATE_FILE" ]]; then
    index=$(cat "$STATE_FILE")
else
    index=-1
fi

index=$(( (index + 1) % count ))

echo "$index" > "$STATE_FILE"

wall="${wallpapers[$index]}"
awww img "$wall" \
    --transition-type any \
    --transition-duration 1. \
    --transition-fps 90