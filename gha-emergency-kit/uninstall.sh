#!/usr/bin/env bash
# Remove only symlinks that this repository created under ~/.local/bin.
set -euo pipefail

source_dir="$(cd "$(dirname "$0")" && pwd)/bin"
destination="${HOME}/.local/bin"
for file in "$source_dir"/*; do
  [[ -f "$file" ]] || continue
  name="$(basename "$file")"
  link="$destination/$name"
  if [[ -L "$link" && "$(readlink -f "$link")" == "$(readlink -f "$file")" ]]; then
    rm -f "$link"
    echo "removed $name"
  fi
done
