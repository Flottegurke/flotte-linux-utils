#!/bin/bash
set -euo pipefail
shopt -s nullglob

if ! command -v git &>/dev/null; then
    echo "❌ git is not installed. (on arch: install it with: sudo pacman -S git)"
    exit 1
fi

if ! command -v ssh-keygen &>/dev/null; then
    echo "❌ ssh-keygen is not installed. (on arch: install it with: sudo pacman -S openssh)"
    exit 1
fi


KEY_DIR="$HOME/.ssh-keys/keys"
mkdir -p "$KEY_DIR"

echo "🔍 Starting SSH key generation workflow..."

read -rp "Device name (e.g., labA): " DEVICE
read -rp "Use case (private/open/commercial): " USECASE
read -rp "Email or identifier to tag key: " COMMENT

KEY_NAME="${DEVICE}_${USECASE}"
KEY_PATH="$KEY_DIR/$KEY_NAME.key"

if [[ -f "$KEY_PATH" ]]; then
    echo "❌ Key already exists at $KEY_PATH"
    exit 1
fi

echo
echo "⚠️  WARNING: This script will track your PRIVATE keys in a local git repository."
echo "   NEVER push this repository to any remote service (GitHub, GitLab, etc.) unless you fully understand the risks."
echo "   Private keys must be kept secret! Treat this repo as highly sensitive."
echo

echo "Enter passphrase for the SSH key (empty for no passphrase):"
read -rsp "Passphrase: " PASSPHRASE
echo
read -rsp "Confirm Passphrase: " PASSPHRASE_CONFIRM
echo
if [[ "$PASSPHRASE" != "$PASSPHRASE_CONFIRM" ]]; then
    echo "❌ Passphrases do not match. Aborting."
    exit 1
fi

echo "⏳ Generating SSH key..."
if [[ -z "$PASSPHRASE" ]]; then
    ssh-keygen -t ed25519 -C "$COMMENT ($DEVICE-$USECASE)" -f "$KEY_PATH" -N ""
else
    ssh-keygen -t ed25519 -C "$COMMENT ($DEVICE-$USECASE)" -f "$KEY_PATH" -N "$PASSPHRASE"
fi

chmod 600 "$KEY_PATH"
chmod 644 "$KEY_PATH.pub"

echo
echo "📁 Key created."

cd "$HOME/.ssh-keys"
if [[ ! -d .git ]]; then
    echo "⚙️ Initializing local git repository..."
    git init
fi

echo
echo "⚠️ IMPORTANT: This git repository contains PRIVATE keys."
echo "   DO NOT push this repo to any remote service unless you know exactly what you are doing."
echo

echo "🔄 Adding files to git..."
git add "$KEY_PATH" "$KEY_PATH.pub"

echo "💾 Committing changes..."
git commit -m "Add $KEY_NAME SSH key (private, public + config)"

echo
echo "✅ Commit complete. Keys are tracked in your local git repository."
echo "⚠️ Remember: NEVER push this repository to a public or untrusted remote!"

echo
echo "🎉 SSH key generation and local tracking complete."
