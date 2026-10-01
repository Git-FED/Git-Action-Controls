#!/usr/bin/env bash
# Symlink all bundled commands into ~/.local/bin.
set -euo pipefail

source_dir="$(cd "$(dirname "$0")" && pwd)/bin"
destination="${HOME}/.local/bin"
mkdir -p "$destination"

for file in "$source_dir"/*; do
  [[ -f "$file" ]] || continue
  name="$(basename "$file")"
  chmod +x "$file"
  ln -sfn "$file" "$destination/$name"
  echo "linked $name -> $destination/$name"
done

case ":$PATH:" in
  *":$destination:"*) ;;
  *)
    echo
    echo "Add this to your shell rc:"
    echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
    ;;
esac
