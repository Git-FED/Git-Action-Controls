#!/usr/bin/env bash
# Dispatch manual workflows sequentially and wait for each result.
# Usage: run-one-by-one.sh [owner/repo] [ref]
set -uo pipefail

repo="${1:-$(gh repo view --json nameWithOwner -q .nameWithOwner)}"
ref="${2:-$(git rev-parse --abbrev-ref HEAD)}"
mapfile -t paths < <(gh api --paginate "/repos/$repo/actions/workflows?per_page=100" \
  --jq '.workflows[] | select(.state == "active") | .path')

for path in "${paths[@]}"; do
  content="$(gh api "/repos/$repo/contents/$path" --jq '.content' 2>/dev/null | base64 --decode 2>/dev/null || true)"
  grep -q 'workflow_dispatch' <<< "$content" || continue
  workflow="$(basename "$path")"
  echo "==> $workflow"
  if ! gh workflow run "$workflow" --repo "$repo" --ref "$ref"; then
    echo "  failed to dispatch $workflow" >&2
    continue
  fi
  sleep 3
  run_id="$(gh run list --repo "$repo" --workflow "$workflow" --event workflow_dispatch \
    --limit 1 --json databaseId --jq '.[0].databaseId' 2>/dev/null || true)"
  if [[ -z "$run_id" || "$run_id" == "null" ]]; then
    echo "  could not find run — dispatch may have failed" >&2
    continue
  fi
  gh run watch "$run_id" --repo "$repo" --exit-status || echo "  $workflow failed or was cancelled"
done
