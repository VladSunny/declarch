#!/usr/bin/env bash

set -euo pipefail

KEY_TYPE="ed25519"
KEY_FILE="$HOME/.ssh/id_${KEY_TYPE}"
KEY_COMMENT="${USER}@${HOSTNAME:-$(hostname)}   $(date +%Y-%m)"

if [[ -f "$KEY_FILE" ]] || [[ -f "${KEY_FILE}.pub" ]]; then
    echo "→ SSH $KEY_FILE exists → skip"
    exit 0
fi

echo "→ Generating SSH key ($KEY_TYPE) with no passphrase..."

ssh-keygen \
    -t "$KEY_TYPE" \
    -C "$KEY_COMMENT" \
    -f "$KEY_FILE" \
    -N "" \
    -q

chmod 600 "$KEY_FILE"

echo ""
echo "Complete"