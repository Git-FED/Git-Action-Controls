# Fuses: root causes and signatures

Use `scripts/find-fuse.sh` for a first pass, then confirm against run details
and the actual workflow definition. Event, actor, and timing are clues, not
proof by themselves.

## Self-triggering loop

**Signature:** `push`, `github-actions[bot]`, seconds apart. A workflow pushes
and its own push trigger starts another run. Confirm with `gh run view <id>` and
search the workflow for `git push`/`git commit`. Remove the write if possible or
add a suitable job-level bot guard; concurrency limits overlap but does not
explain the source.

## Push volume

**Signature:** `push`, a human actor, burst then stops. A rebase, merge, or
rapid development cadence may be normal. Confirm commits in the history. Use
concurrency and narrow paths where the workload is unnecessarily broad.

## Scheduled cron

**Signature:** `schedule`, system actor, repeating at a regular cadence. Search
for `on: schedule` and inspect cron expressions. Delete, correct, or narrow the
schedule; add timeouts and concurrency as separate bounds.

## Chained workflows

**Signature:** `workflow_run`, often a series of workflows after each completion.
Inspect `workflow_run` filters and the source workflow names. Scope the chain or
remove unnecessary cascade edges.

## Dependabot burst

**Signature:** `pull_request`, `dependabot[bot]`, many runs close together.
Confirm in the Dependabot dashboard and PR list. Pause or limit Dependabot, or
make an explicit policy for its CI.

## Matrix explosion

**Signature:** a small number of workflow runs with many concurrent jobs. Inspect
the workflow's `strategy.matrix`. Reduce combinations, cap matrix concurrency,
and cancel stale runs.

## Third-party action loop

**Signature:** repeated runs associated with an external action's commit, PR, or
dispatch behavior. Inspect the action source and logs. Pin, configure, replace,
or isolate the action; keep timeouts and concurrency as damage limits.

## External dispatch or webhook

**Signature:** `repository_dispatch`, `workflow_dispatch`, or API-originated
runs from an unexpected integration. Inspect caller credentials and payload
sources. Rotate/restrict integration credentials and validate the dispatch
policy.
