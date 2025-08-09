#!/bin/bash

set -euo pipefail
shopt -s nullglob globstar

# --- Dependency check ---
MISSING_DEPS=()
REQUIRED_CMDS=("pwd" "find" "basename" "mkdir" "mv" "date" "echo")
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

base_dir=$(pwd)

echo "🔍 Scanning files..."
mapfile -t files < <(find . -type f -name "*.*")
total=${#files[@]}

if (( total == 0 )); then
    echo "❌ No files with extensions found. Exiting."
    exit 1
fi

echo "📂 Current directory: $base_dir"
echo "📄 Found $total files with extensions."

read -p "⚠️  Do you really want to recursively move all $total files into directories named after their extensions? (y/N): " confirm
confirm=${confirm,,}  # to lowercase
if [[ "$confirm" != "y" && "$confirm" != "yes" ]]; then
    echo "❌ Operation cancelled by user."
    exit 0
fi

echo "📦 Starting sort of $total files..."
echo "⏳ Progress will be shown every 5 seconds."
echo
sorted=0
interval_sorted=0
interval_start=$(date +%s)
start_time=$interval_start
last_report=$interval_start

for file in "${files[@]}"; do
    [[ -f "$file" ]] || continue

    ext="${file##*.}"
    ext="${ext,,}"

    dest="$base_dir/$ext"
    mkdir -p "$dest"

    filename=$(basename "$file")
    target="$dest/$filename"

    if [[ -e "$target" ]]; then
        base="${filename%.*}"
        target="$dest/${base}_$RANDOM.$ext"
    fi

    mv "$file" "$target"

    ((sorted++))
    ((interval_sorted++))

    now=$(date +%s)
    if (( now - last_report >= 5 )); then
        percent=$((sorted * 100 / total))
        elapsed=$((now - start_time))

        if (( interval_sorted > 0 )); then
            rate=$((interval_sorted / (now - last_report)))
            remaining=$(( (total - sorted) / (rate > 0 ? rate : 1) ))
        else
            remaining=-1
        fi

        if (( remaining >= 0 )); then
            mins=$((remaining / 60))
            secs=$((remaining % 60))
            eta="~${mins}m ${secs}s remaining"
        else
            eta="estimating..."
        fi

        echo "✅ Sorted $sorted / $total files ($percent%) — $eta"

        last_report=$now
        interval_sorted=0
    fi
done

total_time=$(( $(date +%s) - start_time ))
mins=$((total_time / 60))
secs=$((total_time % 60))

echo
echo "🧹 Cleaning up empty directories..."
find . -type d -empty -not -path . -delete

echo "🎉 Done. Sorted $sorted files in ${mins}m ${secs}s."