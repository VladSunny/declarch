#!/usr/bin/env bash
set -euo pipefail

# Only run if fish is installed and current shell isn't already fish
if command -v fish >/dev/null 2>&1 && [ "${SHELL:-}" != "$(which fish)" ]; then
    echo "Changing default shell to fish …"
    chsh -s "$(which fish)"
    echo "Shell changed. Please log out and back in (or open new terminal)."
fi