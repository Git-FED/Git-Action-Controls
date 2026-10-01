#!/usr/bin/env bash
# Read-only workflow inventory. It does not call GitHub or change files.
set -uo pipefail

repo="${1:-.}"
workflow_dir="$repo/.github/workflows"
if [[ ! -d "$workflow_dir" ]]; then
  echo "No workflow directory found: $workflow_dir" >&2
  exit 1
fi

shopt -s nullglob
files=("$workflow_dir"/*.yml "$workflow_dir"/*.yaml)
printf '%-28s %-26s %-12s %-10s %-14s\n' workflow triggers concurrency timeouts loop-risk
printf '%-28s %-26s %-12s %-10s %-14s\n' -------- -------- ----------- -------- ---------
for file in "${files[@]}"; do
  triggers=()
  grep -qE '^\s*push:' "$file" && triggers+=(push)
  grep -qE '^\s*pull_request:' "$file" && triggers+=(pull_request)
  grep -qE '^\s*schedule:' "$file" && triggers+=(schedule)
  grep -qE '^\s*workflow_dispatch:' "$file" && triggers+=(manual)
  grep -qE '^\s*workflow_call:' "$file" && triggers+=(workflow_call)
  trigger_text="$(IFS=,; echo "${triggers[*]:-none}")"
  concurrency=no
  grep -qE '^concurrency\s*:' "$file" && concurrency=yes
  job_count="$(grep -cE '^  [[:alnum:]_-]+:' "$file" || true)"
  timeout_count="$(grep -cE '^\s*timeout-minutes:' "$file" || true)"
  loop_risk=no
  if grep -qE 'git[[:space:]]+(push|commit)' "$file"; then
    loop_risk=YES
    grep -q 'github-actions\[bot\]' "$file" && loop_risk=guarded
  fi
  printf '%-28s %-26s %-12s %-10s %-14s\n' "$(basename "$file")" "$trigger_text" "$concurrency" "$timeout_count/$job_count" "$loop_risk"
done

echo
echo 'loop-risk=YES means a workflow contains git push/commit without a visible bot guard.'
