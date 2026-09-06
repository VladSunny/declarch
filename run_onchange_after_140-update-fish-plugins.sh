#!/usr/bin/env bash

set -euo pipefail

if ! command -v fish >/dev/null 2>&1; then
    exit 0
fi

fish -c 'if type -q fisher; fisher update; end'
