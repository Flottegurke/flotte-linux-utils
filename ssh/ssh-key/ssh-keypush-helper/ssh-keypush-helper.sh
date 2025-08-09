#!/bin/bash
set -euo pipefail
shopt -s nullglob

if ! command -v sshpass &>/dev/null; then
    echo "❌ sshpass is not installed. (on arch: install it with: sudo pacman -S sshpass)"
    exit 1
fi
if ! command -v fzf &>/dev/null; then
    echo "❌ fzf is not installed. (on arch: install it with: sudo pacman -S fzf)"
    exit 1
fi


echo
echo "📡 Scanning available SSH config entries..."
HOSTS=$(awk '/^Host / { for (i=2; i<=NF; i++) print $i }' ~/.ssh/config)
if [[ -z "$HOSTS" ]]; then
    echo "❌ No entries found in ~/.ssh/config"
    exit 1
fi

SELECTED_HOST=$(echo "$HOSTS" | fzf --prompt="🔌 Select SSH host: " --height=40% --layout=reverse --border)
if [[ -z "$SELECTED_HOST" ]]; then
    echo "❌ No host selected. Aborting."
    exit 1
fi

echo "✅ Selected host: $SELECTED_HOST"

CONFIG=$(ssh -G "$SELECTED_HOST")
HOSTNAME=$(echo "$CONFIG" | awk '/^hostname / {print $2}')
USER=$(echo "$CONFIG" | awk '/^user / {print $2}')
PORT=$(echo "$CONFIG" | awk '/^port / {print $2}')

echo
echo "🔍 SSH config resolved:"
echo "   Hostname: $HOSTNAME"
echo "   User:     $USER"
echo "   Port:     $PORT"

echo
echo "🔑 Searching for keys in ~/.ssh-keys/keys..."
KEYS=(~/.ssh-keys/keys/*.pub)
if [[ ${#KEYS[@]} -eq 0 ]]; then
    echo "❌ No public keys found in ~/.ssh-keys/keys/"
    exit 1
fi

PUBKEY_PATH=$(printf "%s\n" "${KEYS[@]}" | fzf --prompt="🔑 Select public key to push: " --height=40% --layout=reverse --border)
if [[ -z "$PUBKEY_PATH" ]]; then
    echo "❌ No key selected. Aborting."
    exit 1
fi

echo "✅ Selected key: $PUBKEY_PATH"

echo
echo "🔐 Enter SSH password for $USER@$HOSTNAME:"
read -rsp "Password: " SSHPASS
echo

echo "🚀 Pushing SSH key to $USER@$HOSTNAME..."

sshpass -p "$SSHPASS" ssh -o StrictHostKeyChecking=no -p "$PORT" "$USER@$HOSTNAME" "
    mkdir -p ~/.ssh && chmod 700 ~/.ssh && \
    echo '$(cat "$PUBKEY_PATH")' >> ~/.ssh/authorized_keys && \
    chmod 600 ~/.ssh/authorized_keys
"

echo
echo "✅ SSH key successfully pushed to $USER@$HOSTNAME"
echo "🎉 You can now log in without a password!"