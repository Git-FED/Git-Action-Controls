# Emergency runbook

## Hundreds of runs are queued or minutes are draining

1. **Contain the situation.** Run the bundled command from the affected repository:

   ```bash
   /path/to/gha-emergency-kit/bin/stop-actions.sh
   ```

2. **Set a billing backstop.** In GitHub, open **Settings → Billing → Spending limits → Actions** and set a $0 limit. This blocks billable overage, but does not repair the workflow or prevent free-tier usage.

3. **Find the trigger before restoring anything.** Review the run history: event, actor, timing, and head commit. Use `audit.sh` to inspect the local workflow definitions.

4. **Move to controlled testing if needed.** Convert triggers to manual-only, review the diff, and commit it:

   ```bash
   python3 /path/to/gha-emergency-kit/bin/manual-only.py
   git diff .github/workflows/
   ```

5. **Re-enable one workflow.** A disabled workflow cannot be manually dispatched until it is re-enabled:

   ```bash
   gh workflow list
   gh workflow enable ci.yml
   gh workflow run ci.yml --ref main
   ```

6. **Install guardrails before restoring automatic events.** Add concurrency globally, then review each job for a timeout and any job that commits for a bot guard.

   ```yaml
   concurrency:
     group: ${{ github.workflow }}-${{ github.ref }}
     cancel-in-progress: true
   ```

   ```yaml
   jobs:
     build:
       timeout-minutes: 15
       if: ${{ github.actor != 'github-actions[bot]' }}
   ```

## A job remains queued

Runner capacity or a large matrix may be the issue. Check organization runner limits, reduce the matrix, and use concurrency to keep stale work from accumulating.

## A job runs for hours

Set a per-job `timeout-minutes`. The workflow-level concurrency key does not limit duration.

## New runs appear faster than they can be cancelled

Look for `git push`, `git commit`, `schedule`, `workflow_run`, or external dispatches. Do not just re-enable the old workflow; repair the triggering condition first.
