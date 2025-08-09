#!/bin/bash
set -euo pipefail
shopt -s nullglob

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST_DIR="/usr/local/bin"
SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}")"

echo
echo "🔍 Scanning for .sh scripts in repo: $REPO_DIR"

found_any=false

while IFS= read -r -d '' filepath; do
    # Skip this script itself
    if [[ "$(basename "$filepath")" == "$SCRIPT_NAME" ]]; then
        continue
    fi

    base_name="$(basename "$filepath" .sh)"
    link_path="$DEST_DIR/$base_name"

    if [[ -e "$link_path" ]]; then
        echo "⚠️  Skipping '$base_name': already exists in $DEST_DIR"
        continue
    fi

    sudo ln -s "$filepath" "$link_path"
    echo "✅ Linked '$filepath' as '$link_path'"
    found_any=true
done < <(find "$REPO_DIR" -type f -name '*.sh' -print0)

if ! $found_any; then
    echo "ℹ️  No new scripts linked."
else
    echo
    echo "🎉 Done! You can now run all scripts from anywhere (without the .sh extension)."
fi
