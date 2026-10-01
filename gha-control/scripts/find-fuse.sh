#!/usr/bin/env bash
# Read-only diagnosis of GitHub Actions run history.
# Usage: find-fuse.sh [owner/repo] [limit]
set -uo pipefail

repo="${1:-}"
limit="${2:-200}"
if [[ -z "$repo" ]]; then
  repo="$(gh repo view --json nameWithOwner -q .nameWithOwner)" || {
    echo "Could not infer repository; pass owner/repo." >&2
    exit 1
  }
fi
if ! [[ "$limit" =~ ^[1-9][0-9]*$ ]]; then
  echo "Limit must be a positive integer." >&2
  exit 2
fi

runs="$(gh run list --repo "$repo" --limit "$limit" \
  --json createdAt,event,actor,workflowName,headSha,conclusion \
  --jq '.[] | [ .createdAt, .event, (.actor.login // "unknown"), (.workflowName // "unknown"), (.headSha // ""), (.conclusion // "pending") ] | @tsv')" || exit 1

if [[ -z "$runs" ]]; then
  echo "No recent workflow runs found."
  exit 0
fi

echo "Recent runs for $repo (up to $limit)"
printf '%-25s %-17s %-25s %-26s %-12s %s\n' createdAt event actor workflow headSha conclusion
while IFS=$'\t' read -r created event actor workflow sha conclusion; do
  printf '%-25s %-17s %-25s %-26s %-12s %s\n' "$created" "$event" "$actor" "$workflow" "${sha:0:12}" "$conclusion"
done <<< "$runs"

echo
echo 'Counts by (event, actor):'
printf '%-18s %-25s %s\n' event actor count
awk -F '\t' '{counts[$2 SUBSEP $3]++} END {for (key in counts) {split(key, pair, SUBSEP); printf "%-18s %-25s %d\n", pair[1], pair[2], counts[key]}}' <<< "$runs" | sort

count_pair() {
  awk -F '\t' -v event="$1" -v actor="$2" '$2 == event && $3 == actor {n++} END {print n+0}' <<< "$runs"
}
first_sha_for() {
  awk -F '\t' -v event="$1" -v actor="$2" '$2 == event && $3 == actor && $5 != "" {print $5; exit}' <<< "$runs"
}
show_author() {
  local sha="$1"
  [[ -z "$sha" ]] && return
  local author
  author="$(gh api "/repos/$repo/commits/$sha" --jq '.author.login // .commit.author.name // "unknown"' 2>/dev/null || true)"
  echo "  head commit $sha author: ${author:-unknown}"
}

verdict="No strong signature detected; inspect docs/FUSES.md and the run table."
loop_count="$(count_pair push 'github-actions[bot]')"
dependabot_count="$(count_pair pull_request 'dependabot[bot]')"
schedule_count="$(awk -F '\t' '$2 == "schedule" {n++} END {print n+0}' <<< "$runs")"
chain_count="$(awk -F '\t' '$2 == "workflow_run" {n++} END {print n+0}' <<< "$runs")"
human_push_count="$(awk -F '\t' '$2 == "push" && $3 != "github-actions[bot]" {n++} END {print n+0}' <<< "$runs")"

if [[ "$loop_count" -ge 3 ]]; then
  echo
echo "Flag: LOOP candidate — $loop_count push runs by github-actions[bot]."
  show_author "$(first_sha_for push 'github-actions[bot]')"
  verdict="Likely fuse: self-triggering loop — see docs/FUSES.md#self-triggering-loop."
elif [[ "$schedule_count" -ge 3 ]]; then
  echo
echo "Flag: CRON candidate — $schedule_count scheduled runs in the sampled history."
  verdict="Likely fuse: scheduled cron — see docs/FUSES.md#scheduled-cron."
elif [[ "$chain_count" -ge 2 ]]; then
  echo
echo "Flag: CHAINED candidate — $chain_count workflow_run events."
  verdict="Likely fuse: workflow_run cascade — see docs/FUSES.md#chained-workflows."
elif [[ "$dependabot_count" -ge 3 ]]; then
  echo
echo "Flag: DEPENDABOT candidate — $dependabot_count Dependabot pull-request runs."
  show_author "$(first_sha_for pull_request 'dependabot[bot]')"
  verdict="Likely fuse: Dependabot burst — see docs/FUSES.md#dependabot-burst."
elif [[ "$human_push_count" -ge 5 ]]; then
  echo
echo "Flag: PUSH VOLUME candidate — $human_push_count human/unknown push runs."
  verdict="Likely fuse: push volume — see docs/FUSES.md#push-volume."
fi

echo
echo "$verdict"
echo 'This heuristic is read-only and cannot prove all causes; confirm against the workflow definition and run details.'
