#!/usr/bin/env bash

set -euo pipefail

if ! command -v fish >/dev/null 2>&1; then
    echo "fish is not installed; skipping default shell setup."
    exit 0
fi

FISH_PATH="$(command -v fish)"

if [[ "${SHELL:-}" == "$FISH_PATH" ]]; then
    echo "Default shell is already fish."
    exit 0
fi

echo "Changing default shell to fish..."
chsh -s "$FISH_PATH"
echo "Shell changed. Please log out and back in, or open a new terminal."
