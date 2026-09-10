#!/usr/bin/env bash
set -euo pipefail

RUNTIME_DIR="${XDG_RUNTIME_DIR:?XDG_RUNTIME_DIR is required}"
STATE_DIR="${RUNTIME_DIR}/hypr"
PID_FILE="${STATE_DIR}/lid-sleep-inhibit.pid"
HANDLER_PID_FILE="${STATE_DIR}/lid-switch-handler-inhibit.pid"

is_enabled() {
    [[ -s "$PID_FILE" ]] || return 1

    local pid
    pid="$(<"$PID_FILE")"
    [[ "$pid" =~ ^[0-9]+$ ]] || return 1
    kill -0 "$pid" 2>/dev/null
}

cleanup_stale_pid() {
    if [[ -e "$PID_FILE" ]] && ! is_enabled; then
        rm -f "$PID_FILE"
    fi
}

handler_inhibitor_is_running() {
    [[ -s "$HANDLER_PID_FILE" ]] || return 1

    local pid
    pid="$(<"$HANDLER_PID_FILE")"
    [[ "$pid" =~ ^[0-9]+$ ]] || return 1
    kill -0 "$pid" 2>/dev/null
}

cleanup_stale_handler_pid() {
    if [[ -e "$HANDLER_PID_FILE" ]] && ! handler_inhibitor_is_running; then
        rm -f "$HANDLER_PID_FILE"
    fi
}

print_status() {
    cleanup_stale_pid

    if is_enabled; then
        printf '{"text":"󰅶","alt":"no-sleep","class":"no-sleep","tooltip":"Lid close locks only; sleep is inhibited"}\n'
    else
        printf '{"text":"󰒲","alt":"sleep","class":"sleep","tooltip":"Lid close locks and suspends"}\n'
    fi
}

enable_inhibitor() {
    cleanup_stale_pid
    if is_enabled; then
        return 0
    fi

    mkdir -p "$STATE_DIR"
    systemd-inhibit \
        --what=handle-lid-switch \
        --mode=block \
        --who=waybar-lid-sleep \
        --why="Keep laptop awake while lid is closed" \
        sleep infinity &
    printf '%s\n' "$!" > "$PID_FILE"
}

disable_inhibitor() {
    cleanup_stale_pid
    if ! is_enabled; then
        return 0
    fi

    local pid
    pid="$(<"$PID_FILE")"
    kill "$pid" 2>/dev/null || true
    rm -f "$PID_FILE"
}

start_logind_inhibitor() {
    cleanup_stale_handler_pid
    if handler_inhibitor_is_running; then
        return 0
    fi

    local hyprland_pid=""
    local hyprland_lock="${RUNTIME_DIR}/hypr/${HYPRLAND_INSTANCE_SIGNATURE:-}/hyprland.lock"
    if [[ -r "$hyprland_lock" ]]; then
        read -r hyprland_pid < "$hyprland_lock"
    fi

    [[ "$hyprland_pid" =~ ^[0-9]+$ ]] || return 0

    mkdir -p "$STATE_DIR"
    systemd-inhibit \
        --what=handle-lid-switch \
        --mode=block \
        --who=hyprland-lid-handler \
        --why="Let Hyprland lock before handling lid sleep" \
        bash -c 'while kill -0 "$1" 2>/dev/null; do sleep 30; done' bash "$hyprland_pid" &
    printf '%s\n' "$!" > "$HANDLER_PID_FILE"
}

lock_screen() {
    if pgrep -x hyprlock >/dev/null; then
        return 0
    fi

    hyprlock &

    local _attempt
    for _attempt in {1..20}; do
        if pgrep -x hyprlock >/dev/null; then
            sleep 0.5
            return 0
        fi
        sleep 0.05
    done
}

handle_lid_close() {
    lock_screen

    if ! is_enabled; then
        systemctl suspend
    fi
}

case "${1:-status}" in
    status)
        print_status
        ;;
    toggle)
        if is_enabled; then
            disable_inhibitor
        else
            enable_inhibitor
        fi
        print_status
        ;;
    enable)
        enable_inhibitor
        print_status
        ;;
    disable)
        disable_inhibitor
        print_status
        ;;
    inhibit-logind)
        start_logind_inhibitor
        ;;
    close)
        handle_lid_close
        ;;
    *)
        printf 'usage: %s [status|toggle|enable|disable|inhibit-logind|close]\n' "$0" >&2
        exit 2
        ;;
esac
