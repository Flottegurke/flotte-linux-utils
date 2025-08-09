#!/bin/bash
set -euo pipefail

echo
read -rp "📦 Do you want to update the system? [y/N] " CONFIRM
if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
    echo "❌ Update canceled."
    exit 0
fi

# --- Dotfiles update ---
echo
DOTFILES_DIR="$HOME/.config/dotfiles"
if [[ -d "$DOTFILES_DIR/.git" ]]; then
    echo "🔄 Updating dotfiles repository in ~/.config/dotfiles..."
    git -C "$DOTFILES_DIR" pull

    UPDATE_SCRIPT="$DOTFILES_DIR/updateDotfiles.sh"
    if [[ -x "$UPDATE_SCRIPT" ]]; then
        echo "🚀 Running updateDotfiles.sh..."
        "$UPDATE_SCRIPT"
    else
        echo "⚠️  $UPDATE_SCRIPT not found or not executable."
        exit 1
    fi
else
    echo "ℹ️  No dotfiles git repo found in ~/.config/dotfiles."
fi

# --- System update ---
echo
echo "🔧 Checking for yay..."
if command -v yay &>/dev/null; then
    echo "📦 Updating AUR and system packages with yay..."
    yay -Syu --noconfirm
else
    echo "⚠️  yay is not installed. Falling back to pacman only."
    echo "   (tip: install yay with: sudo pacman -S yay)"
    echo
    echo "📦 Updating system packages with pacman..."
    sudo pacman -Syu --noconfirm
fi

# --- Reboot prompt ---
echo
read -rp "🔁 Do you want to reboot the system now? [y/N] " REBOOT_CONFIRM
if [[ "$REBOOT_CONFIRM" =~ ^[Yy]$ ]]; then
    echo "♻️  Rebooting..."
    systemctl reboot
else
    echo "✅ Update complete. No reboot."
fi
