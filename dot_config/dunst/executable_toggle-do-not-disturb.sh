#!/usr/bin/env bash

set -euo pipefail

readonly STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/dunst"
readonly STATE_FILE="$STATE_DIR/do-not-disturb"
readonly LOW_RULE="do-not-disturb-low"
readonly NORMAL_RULE="do-not-disturb-normal"

read_state() {
    local state="off"

    if [[ -f "$STATE_FILE" ]]; then
        IFS= read -r state < "$STATE_FILE" || state="off"
    fi

    case "$state" in
        on|off) printf '%s\n' "$state" ;;
        *)      printf 'off\n' ;;
    esac
}

set_rules() {
    local target="$1"
    local rollback

    if [[ "$target" == "enable" ]]; then
        rollback="disable"
    else
        rollback="enable"
    fi

    dunstctl rule "$LOW_RULE" "$target"
    if ! dunstctl rule "$NORMAL_RULE" "$target"; then
        dunstctl rule "$LOW_RULE" "$rollback" || true
        return 1
    fi
}

write_state() {
    local state="$1"
    local temporary_file

    mkdir -p "$STATE_DIR"
    temporary_file="$STATE_FILE.tmp.$$"
    printf '%s\n' "$state" > "$temporary_file"
    mv -f -- "$temporary_file" "$STATE_FILE"
}

notify_state() {
    local label="$1"

    dunstify \
        -a dunst-dnd \
        -u normal \
        -h string:x-dunst-stack-tag:dunst-dnd \
        "Do not disturb" "$label"
}

main() {
    local command="${1:-}"
    local current_state
    local next_state
    local rule_action
    local notification_label

    case "$command" in
        init)
            current_state="$(read_state)"
            if [[ "$current_state" == "on" ]]; then
                rule_action="enable"
            else
                rule_action="disable"
            fi

            set_rules "$rule_action"
            write_state "$current_state"
            ;;
        toggle)
            current_state="$(read_state)"
            if [[ "$current_state" == "on" ]]; then
                next_state="off"
                rule_action="disable"
                notification_label="Off"
            else
                next_state="on"
                rule_action="enable"
                notification_label="On"
            fi

            set_rules "$rule_action"
            write_state "$next_state"
            notify_state "$notification_label"
            ;;
        *)
            printf 'Usage: %s init|toggle\n' "${0##*/}" >&2
            return 2
            ;;
    esac
}

main "$@"
