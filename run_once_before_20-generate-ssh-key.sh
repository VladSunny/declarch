#!/usr/bin/env bash

set -euo pipefail

KEY_TYPE="ed25519"
SSH_DIR="$HOME/.ssh"
KEY_FILE="$SSH_DIR/id_${KEY_TYPE}"
KEY_COMMENT="${USER}@${HOSTNAME:-$(hostname)}   $(date +%Y-%m)"

fail() {
    echo "SSH key setup failed: $*" >&2
    exit 1
}

command -v ssh-keygen >/dev/null 2>&1 || fail "required command 'ssh-keygen' is unavailable."

install -d -m 0700 "$SSH_DIR"

if [[ -f "$KEY_FILE" ]] || [[ -f "${KEY_FILE}.pub" ]]; then
    echo "SSH $KEY_FILE exists; skipping key generation."
    exit 0
fi

echo "Generating SSH key ($KEY_TYPE) with no passphrase..."

ssh-keygen \
    -t "$KEY_TYPE" \
    -C "$KEY_COMMENT" \
    -f "$KEY_FILE" \
    -N "" \
    -q

chmod 600 "$KEY_FILE"

echo "SSH key setup completed successfully."
