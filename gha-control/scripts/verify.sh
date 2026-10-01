#!/usr/bin/env bash
# Read-only verification of workflow safety guard coverage.
# Usage: verify.sh [path-to-repository]
set -uo pipefail

repo="${1:-.}"
workflow_dir="$repo/.github/workflows"

if [[ ! -d "$workflow_dir" ]]; then
  echo "FAIL: workflow directory not found: $workflow_dir" >&2
  exit 1
fi

shopt -s nullglob
files=("$workflow_dir"/*.yml "$workflow_dir"/*.yaml)
if [[ ${#files[@]} -eq 0 ]]; then
  echo "FAIL: no workflow files found in $workflow_dir" >&2
  exit 1
fi

total=0
failed=0
for file in "${files[@]}"; do
  total=$((total + 1))
  name="$(basename "$file")"
  gaps=()

  grep -qE '^concurrency\s*:' "$file" || gaps+=("concurrency")
  grep -qE '^\s*cancel-in-progress:\s*true\s*(#.*)?$' "$file" || gaps+=("cancel-in-progress")
  grep -qE '^\s*timeout-minutes:\s*[0-9]+' "$file" || gaps+=("timeout-minutes")

  if grep -qE 'git[[:space:]]+(push|commit)' "$file" && ! grep -q 'github-actions\[bot\]' "$file"; then
    gaps+=("bot-guard")
  fi

  if [[ ${#gaps[@]} -eq 0 ]]; then
    printf '[ OK ] %s\n' "$name"
  else
    printf '[FAIL] %s — missing: %s\n' "$name" "${gaps[*]}"
    failed=$((failed + 1))
  fi
done

echo
printf 'Checked %d workflow(s); %d with gaps.\n' "$total" "$failed"
echo 'Account-level spending limits cannot be checked locally.'
echo "Verify manually: Settings → Billing → Spending limits → Actions → \$0"

[[ "$failed" -eq 0 ]]
