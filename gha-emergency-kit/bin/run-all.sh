#!/usr/bin/env bash
# Dispatch each active workflow that declares workflow_dispatch.
# Usage: run-all.sh [owner/repo] [ref]
set -uo pipefail

repo="${1:-}"
ref="${2:-}"
if [[ -z "$repo" ]]; then
  repo="$(gh repo view --json nameWithOwner -q .nameWithOwner)" || exit 1
fi
if [[ -z "$ref" ]]; then
  ref="$(git rev-parse --abbrev-ref HEAD)" || {
    echo "Could not infer a ref. Pass it as the second argument." >&2
    exit 1
  }
fi

echo "Repo: $repo"
echo "Ref:  $ref"
mapfile -t paths < <(gh api --paginate "/repos/$repo/actions/workflows?per_page=100" \
  --jq '.workflows[] | select(.state == "active") | .path')

workflows=()
for path in "${paths[@]}"; do
  content="$(gh api "/repos/$repo/contents/$path" --jq '.content' 2>/dev/null | base64 --decode 2>/dev/null || true)"
  if grep -q 'workflow_dispatch' <<< "$content"; then
    workflows+=("$(basename "$path")")
  fi
done

if [[ ${#workflows[@]} -eq 0 ]]; then
  echo "No active workflow_dispatch-enabled workflows found."
  exit 0
fi

echo "Dispatchable workflows:"
printf '  - %s\n' "${workflows[@]}"
for workflow in "${workflows[@]}"; do
  echo "==> Dispatching $workflow"
  if gh workflow run "$workflow" --repo "$repo" --ref "$ref"; then
    sleep 2
  else
    echo "    failed to dispatch $workflow" >&2
  fi
done

echo "All dispatched. Watch with: gh run list --limit 20 --event workflow_dispatch"
