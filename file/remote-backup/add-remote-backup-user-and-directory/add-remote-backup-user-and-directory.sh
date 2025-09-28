#!/bin/bash
set -euo pipefail
shopt -s nullglob

# --- Dependency check ---
MISSING_DEPS=()
REQUIRED_CMDS=("getent" "sudo" "addgroup" "adduser" "usermod" "mkdir" "chown" "chmod" "grep" "tee" "systemctl" "read")
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

BACKUP_USER="backup"
BACKUP_HOME="/remote/backups"

# --- Ensure root-owned chroot directory ---
if [ ! -d "$BACKUP_HOME" ]; then
    echo "Creating chroot base directory $BACKUP_HOME..."
    sudo mkdir -p "$BACKUP_HOME"
fi
echo "Setting $BACKUP_HOME ownership to root:root and permissions 755..."
sudo chown root:root "$BACKUP_HOME"
sudo chmod 755 "$BACKUP_HOME"

# --- Create group if missing ---
if ! getent group "$BACKUP_USER" >/dev/null; then
    echo "Creating group $BACKUP_USER..."
    sudo addgroup --system "$BACKUP_USER"
fi

# --- Create or update backup user ---
if ! id "$BACKUP_USER" &>/dev/null; then
    echo "Creating backup user..."
    sudo adduser --system --shell /usr/sbin/nologin --home "$BACKUP_HOME/$BACKUP_USER" --ingroup "$BACKUP_USER" "$BACKUP_USER"
else
    echo "User $BACKUP_USER already exists. Ensuring it has the correct primary group..."
    sudo usermod -g "$BACKUP_USER" "$BACKUP_USER"
fi

# --- Ask for folders interactively ---
read -p "Enter backup folder names (space-separated): " -a FOLDERS

# --- Create backup folders and set permissions ---
for folder in "${FOLDERS[@]}"; do
    FULL_PATH="$BACKUP_HOME/$folder"
    if [ ! -d "$FULL_PATH" ]; then
        echo "Creating folder $FULL_PATH..."
        sudo mkdir -p "$FULL_PATH"
    fi

    echo "Setting ownership and permissions for $FULL_PATH..."
    sudo chown "$BACKUP_USER:$BACKUP_USER" "$FULL_PATH"
    sudo chmod 700 "$FULL_PATH"
done

# --- Set up .ssh folder for authorized keys ---
SSH_DIR="$BACKUP_HOME/$BACKUP_USER/.ssh"
if [ ! -d "$SSH_DIR" ]; then
    echo "Creating .ssh directory for backup user..."
    sudo mkdir -p "$SSH_DIR"
fi
sudo chown -R "$BACKUP_USER:$BACKUP_USER" "$SSH_DIR"
sudo chmod 700 "$SSH_DIR"
echo "You can now place public keys into $SSH_DIR/authorized_keys"
echo "Example: sudo nano $SSH_DIR/authorized_keys (paste keys) and chmod 600"

# --- Configure SSH restrictions ---
SSHD_CONF="/etc/ssh/sshd_config"
MATCH_BLOCK="Match User $BACKUP_USER
    ForceCommand internal-sftp
    ChrootDirectory $BACKUP_HOME
    AllowTcpForwarding no
    X11Forwarding no"

if ! grep -q "Match User $BACKUP_USER" "$SSHD_CONF"; then
    echo "Adding SSH restriction for $BACKUP_USER..."
    echo -e "\n$MATCH_BLOCK" | sudo tee -a "$SSHD_CONF"
    sudo systemctl reload sshd
else
    echo "SSH restriction for $BACKUP_USER already configured."
fi

echo "Backup user setup complete."
echo "Folders configured: ${FOLDERS[*]}"
