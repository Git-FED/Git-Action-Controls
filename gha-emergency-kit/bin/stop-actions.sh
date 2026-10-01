#!/usr/bin/env bash
# Emergency stop: cancel live runs, then disable active workflows.
# Usage: stop-actions.sh [owner/repo]
# This script changes GitHub state. It never modifies local source files.
set -uo pipefail

repo="${1:-}"
if [[ -z "$repo" ]]; then
  repo="$(gh repo view --json nameWithOwner -q .nameWithOwner)" || {
    echo "Could not infer a repository. Pass owner/repo explicitly." >&2
    exit 1
  }
fi

echo "Target repository: $repo"
echo "Cancelling non-completed workflow runs..."

run_ids="$(gh api --paginate "/repos/$repo/actions/runs?per_page=100" \
  --jq '.workflow_runs[] | select(.status != "completed") | .id' 2>/dev/null)" || {
  echo "Could not list workflow runs." >&2
  exit 1
}

if [[ -z "$run_ids" ]]; then
  echo "  No live runs found."
else
  while IFS= read -r run_id; do
    [[ -z "$run_id" ]] && continue
    echo "  cancelling run $run_id"
    # A run may finish between listing and cancellation. Continue in that case.
    gh api -X POST "/repos/$repo/actions/runs/$run_id/force-cancel" >/dev/null 2>&1 || true
  done <<< "$run_ids"
fi

echo "Disabling active workflows..."
workflow_ids="$(gh api --paginate "/repos/$repo/actions/workflows?per_page=100" \
  --jq '.workflows[] | select(.state == "active") | .id')" || {
  echo "Could not list workflows." >&2
  exit 1
}

failed=0
if [[ -z "$workflow_ids" ]]; then
  echo "  No active workflows found."
else
  while IFS= read -r workflow_id; do
    [[ -z "$workflow_id" ]] && continue
    echo "  disabling workflow $workflow_id"
    if ! gh api -X PUT "/repos/$repo/actions/workflows/$workflow_id/disable" >/dev/null; then
      failed=1
    fi
  done <<< "$workflow_ids"
fi

if [[ "$failed" -eq 0 ]]; then
  echo "Done. Nothing can run until you re-enable workflows."
else
  echo "Some workflows could not be disabled; review the errors above." >&2
  exit 1
fi
