#!/bin/bash
set -euo pipefail

echo
read -rp "📦 Do you want to update the system? [y/N] " CONFIRM
if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
    echo "❌ Update canceled."
    exit 0
fi

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

echo
read -rp "🔁 Do you want to reboot the system now? [y/N] " REBOOT_CONFIRM
if [[ "$REBOOT_CONFIRM" =~ ^[Yy]$ ]]; then
    echo "♻️  Rebooting..."
    systemctl reboot
else
    echo "✅ Update complete. No reboot."
fi
