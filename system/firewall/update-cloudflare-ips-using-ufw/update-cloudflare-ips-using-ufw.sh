#!/bin/bash

# Interface to apply the rules on
IFACE="eth0"

# --- Dependency check ---
MISSING_DEPS=()
REQUIRED_CMDS=("ufw" "grep" "awk" "tac" "curl")
for cmd in "${REQUIRED_CMDS[@]}"; do
    if ! command -v "$cmd" &>/dev/null; then
        MISSING_DEPS+=("$cmd")
    fi
done
if ((${#MISSING_DEPS[@]} > 0)); then
    echo "❌ Missing required dependencies: ${MISSING_DEPS[*]}"
    echo "Please install them before running this script."
    exit 1
fi
echo

CF_URLS=(
    "https://www.cloudflare.com/ips-v4"
    "https://www.cloudflare.com/ips-v6"
)

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root" >&2
    exit 1
fi

# Flush old Cloudflare rules
echo "Deleting old Cloudflare rules..."
ufw status numbered | grep 'Cloudflare' | awk -F'[][]' '{print $2}' | tac | while read -r num; do
    if [[ -n "$num" ]]; then
        ufw --force delete "$num"
    fi
done

# Add updated ranges
echo "Adding updated Cloudflare IP ranges..."
for url in "${CF_URLS[@]}"; do
    ips=$(curl -s "$url")
    if [[ -z "$ips" ]]; then
        echo "Failed to fetch IP list from $url" >&2
        continue
    fi

    while read -r ip; do
        [[ -z "$ip" ]] && continue
        ufw allow in on "$IFACE" proto tcp from "$ip" to any port 80 comment 'Cloudflare'
        ufw allow in on "$IFACE" proto tcp from "$ip" to any port 443 comment 'Cloudflare'
    done <<< "$ips"
done

echo "Cloudflare rules updated successfully."
