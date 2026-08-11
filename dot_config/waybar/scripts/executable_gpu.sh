#!/bin/bash

set -euo pipefail

export LC_ALL=C

readonly QUERY="utilization.gpu,temperature.gpu,memory.used,memory.total,power.draw"

if ! stats=$(nvidia-smi \
    --id=0 \
    --query-gpu="$QUERY" \
    --format=csv,noheader,nounits 2>/dev/null); then
    exit 0
fi

IFS=',' read -r utilization temperature memory_used memory_total power_draw <<<"$stats"

utilization=${utilization//[[:space:]]/}
temperature=${temperature//[[:space:]]/}
memory_used=${memory_used//[[:space:]]/}
memory_total=${memory_total//[[:space:]]/}
power_draw=${power_draw//[[:space:]]/}

if ! [[ $utilization =~ ^[0-9]+$ &&
        $temperature =~ ^[0-9]+$ &&
        $memory_used =~ ^[0-9]+$ &&
        $memory_total =~ ^[0-9]+$ &&
        $power_draw =~ ^[0-9]+([.][0-9]+)?$ ]]; then
    exit 0
fi

if ((utilization > 100 || memory_used > memory_total)); then
    exit 0
fi

memory_used_gib=$(awk -v mib="$memory_used" 'BEGIN { printf "%.1f", mib / 1024 }')
memory_total_gib=$(awk -v mib="$memory_total" 'BEGIN { printf "%.1f", mib / 1024 }')

class=""
if ((utilization >= 90)); then
    class="critical"
elif ((utilization >= 75)); then
    class="warning"
fi

printf '{"text":"%s%%","tooltip":"󰢮  %s%%\\n󰔏  %s°C\\n󰍛  %s / %s GiB\\n󰓅  %s W","class":"%s","percentage":%s}\n' \
    "$utilization" \
    "$utilization" \
    "$temperature" \
    "$memory_used_gib" \
    "$memory_total_gib" \
    "$power_draw" \
    "$class" \
    "$utilization"
