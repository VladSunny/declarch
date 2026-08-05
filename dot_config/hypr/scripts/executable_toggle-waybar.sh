#!/usr/bin/env bash

if pgrep -u "$(id -un)" -x waybar >/dev/null 2>&1; then
    pkill -u "$(id -un)" -x waybar
else
    if command -v setsid >/dev/null 2>&1; then
        setsid waybar >/dev/null 2>&1 &
    else
        nohup waybar >/dev/null 2>&1 &
    fi
fi