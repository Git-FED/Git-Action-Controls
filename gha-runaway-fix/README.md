# gha-runaway-fix

A focused, layered remediation kit for runaway GitHub Actions.

## Why a single fix is not enough

| Single control | What it still leaves exposed |
| --- | --- |
| Manual-only triggers | The original loop returns when automatic triggers are restored. |
| Concurrency | One job can still hang for a long time. |
| Timeout | Fast loops can still keep creating work. |
| Bot guard | Cron, workflow chains, human pushes, and external dispatches can still run. |
| $0 spending limit | Free-tier minutes can still be consumed. |

Use multiple independent controls, then verify the workflow definitions. This
repository does **not** claim to make every unknown GitHub failure impossible.

## The layers

1. **Account-level backstop:** set **Settings → Billing → Spending limits → Actions → $0**.
2. **Concurrency:** keep only the newest run for the same workflow/ref.
3. **Timeout:** bound each job's duration.
4. **Bot guard:** prevent a job that pushes commits from triggering itself.
5. **Verification:** check that declared workflow files contain expected safeguards.

## Quick path

```bash
./scripts/stop-actions.sh owner/repo
python3 ./scripts/add-guards.py /path/to/repo
# Add per-job timeout-minutes and bot guards after review.
./scripts/verify.sh /path/to/repo
```

See [the permanent-fix guide](docs/PERMANENT-FIX.md) for the safety boundary,
[causes](docs/CAUSES.md) for root-cause patterns, and [copy-paste fixes](docs/FIXES.md).

## Requirements

`gh` with repository/workflow access, Bash 4+, Python 3, Git, and `grep`.

## License

MIT — see [LICENSE](LICENSE).
