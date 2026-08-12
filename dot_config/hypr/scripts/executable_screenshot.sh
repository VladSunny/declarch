#!/usr/bin/env bash

set -euo pipefail

MODE=${1:-}
SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
TIMESTAMP=$(date +'%Y-%m-%d_%H-%M-%S-%3N')
SCREENSHOT_FILE="$SCREENSHOT_DIR/screenshot-$TIMESTAMP.png"
TEMP_FILE=""

notify_error() {
    notify-send -a "Screenshot" -u critical "Screenshot failed" "$1" || true
}

cleanup() {
    [[ -z $TEMP_FILE || ! -e $TEMP_FILE ]] || rm -f -- "$TEMP_FILE"
}

trap cleanup EXIT

case "$MODE" in
    area | monitor)
        ;;
    *)
        printf 'Usage: %s {area|monitor}\n' "${0##*/}" >&2
        exit 2
        ;;
esac

if ! mkdir -p -- "$SCREENSHOT_DIR"; then
    notify_error "Could not create $SCREENSHOT_DIR"
    exit 1
fi

while [[ -e $SCREENSHOT_FILE ]]; do
    SCREENSHOT_FILE="$SCREENSHOT_DIR/screenshot-$TIMESTAMP-$RANDOM.png"
done

TEMP_FILE=$(mktemp "$SCREENSHOT_DIR/.screenshot.XXXXXX.png")

if [[ $MODE == area ]]; then
    if ! GEOMETRY=$(slurp); then
        exit 0
    fi

    if ! grim -g "$GEOMETRY" "$TEMP_FILE"; then
        notify_error "Could not capture the selected area"
        exit 1
    fi
else
    if ! OUTPUT=$(hyprctl monitors -j | jq -er '[.[] | select(.focused == true) | .name][0] // empty'); then
        notify_error "Could not determine the monitor under the pointer"
        exit 1
    fi

    if ! grim -o "$OUTPUT" "$TEMP_FILE"; then
        notify_error "Could not capture monitor $OUTPUT"
        exit 1
    fi
fi

mv -- "$TEMP_FILE" "$SCREENSHOT_FILE"
TEMP_FILE=""

if wl-copy --type image/png < "$SCREENSHOT_FILE"; then
    notify-send -a "Screenshot" -u low "Screenshot saved" "${SCREENSHOT_FILE##*/} copied to clipboard" || true
else
    notify-send -a "Screenshot" -u normal "Screenshot saved" "${SCREENSHOT_FILE##*/}; clipboard copy failed" || true
    exit 1
fi
