#!/usr/bin/env bash
# Restore only workflow files that are currently manual-only from HEAD~1.
# Usage: restore.sh [path-to-repository]
# This is deliberately confirmation-gated because it overwrites YAML.
set -uo pipefail

repo="${1:-.}"
cd "$repo" || exit 1
workflow_dir=".github/workflows"

if [[ ! -d "$workflow_dir" ]]; then
  echo "No workflow directory found." >&2
  exit 1
fi
if ! git rev-parse --verify HEAD~1 >/dev/null 2>&1; then
  echo "HEAD~1 is unavailable; there is no previous committed version to restore." >&2
  exit 1
fi
if [[ -n "$(git status --porcelain -- "$workflow_dir")" ]]; then
  echo "Refusing to restore: workflow files have uncommitted changes." >&2
  echo "Commit, stash, or inspect those changes first." >&2
  exit 1
fi

shopt -s nullglob
candidates=()
is_manual_only() {
  awk '
    /^on:[[:space:]]*$/ { in_on=1; next }
    in_on && /^[^[:space:]#]/ { exit }
    in_on && /^[[:space:]]*workflow_dispatch:[[:space:]]*$/ { seen=1; next }
    in_on && /^[[:space:]]*($|#)/ { next }
    in_on { other=1 }
    END { exit !(seen && !other) }
  ' "$1"
}

for file in "$workflow_dir"/*.yml "$workflow_dir"/*.yaml; do
  relative="${file#./}"
  if is_manual_only "$file"; then
    if git cat-file -e "HEAD~1:$relative" 2>/dev/null; then
      candidates+=("$relative")
    fi
  fi
done

if [[ ${#candidates[@]} -eq 0 ]]; then
  echo "No manual-only workflow files with a HEAD~1 version were found."
  exit 0
fi

echo "The following files will be restored from HEAD~1:"
printf '  - %s\n' "${candidates[@]}"
read -r -p 'Type yes to continue: ' answer
if [[ "$answer" != "yes" ]]; then
  echo "No files changed."
  exit 0
fi

for relative in "${candidates[@]}"; do
  git show "HEAD~1:$relative" > "$relative"
  echo "restored $relative"
done

echo "Review with: git diff -- .github/workflows/"
