#!/bin/bash
set -euo pipefail

# --- Dependency check ---
MISSING_DEPS=()
REQUIRED_CMDS=("pacman" "git" "systemctl")
OPTIONAL_CMDS=("yay")
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
for cmd in "${OPTIONAL_CMDS[@]}"; do
    if ! command -v "$cmd" &>/dev/null; then
        echo "ℹ️  Optional dependency missing: $cmd"
    fi
done
echo

read -rp "📦 Do you want to update all system packages? [y/N] " CONFIRM
if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
    echo "Skipping system update..."
else

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

# --- flotte-linux-utils update ---
echo
UTILS_DIR="$HOME/.config/flotte-linux-utils"
if [[ -d "$UTILS_DIR/.git" ]]; then
    echo "🔄 Updating flotte-linux-utils repository in ~/.config/flotte-linux-utils..."
    git -C "$UTILS_DIR" pull

    UTILS_UPDATE_SCRIPT="$UTILS_DIR/updateFlotteLinuxUtils.sh"
    if [[ -x "$UTILS_UPDATE_SCRIPT" ]]; then
        echo "🚀 Running updateFlotteLinuxUtils.sh..."
        "$UTILS_UPDATE_SCRIPT"
    else
        echo "⚠️  $UTILS_UPDATE_SCRIPT not found or not executable."
        exit 1
    fi
else
    echo "ℹ️  ❌ flotte-linux-utils git repo not found in ~/.config/flotte-linux-utils."
    echo "ℹ️  please remove the current flotte-linux-utils repo and clone it again in the ~/.config directory (cd ~/.config && git clone git@github.com:flottegurke/flotte-linux-utils.git)"
    exit 1
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
