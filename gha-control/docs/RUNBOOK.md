# Controlled response runbook

## Hundreds of runs queued or minutes draining

1. Contain: run `scripts/stop-actions.sh` or disable Actions through the UI.
2. Set the $0 spending limit as a billing backstop.
3. Run `scripts/find-fuse.sh`; do **not** skip root-cause investigation.
4. Confirm the matching fuse in [FUSES.md](FUSES.md).
5. Add concurrency with `add-guards.py`; add reviewed job timeouts and bot guards.
6. Run `verify.sh` and resolve reported gaps.
7. Re-enable one workflow and test one event.
8. Watch run history for at least ten minutes before restoring more automation.

## A single job is queued

Investigate runner capacity, workflow concurrency, and matrix size. A queued job
may not be a loop; use job-level logs and organization runner limits.

## A single job runs for hours

Add or lower its `timeout-minutes`, then inspect the hanging step. A timeout
limits cost and capacity but does not correct the underlying command.

## Runs appear faster than they can be cancelled

Prioritize actor/event diagnosis. Bot `push` runs suggest recursion; regular
schedule runs suggest cron; `workflow_run` suggests a cascade.

## Dependabot opens many PRs

Confirm the `dependabot[bot]` signature. Pause or limit Dependabot separately;
workflow guards only control what happens after a PR event reaches CI.
