# gha-control

An honest guide and toolkit for controlling GitHub Actions: find the fuse,
contain the fire, and add guards for distinct failure modes.

## Three things can go wrong

1. **Loop:** a workflow's own push, schedule, or chain creates more runs.
2. **Volume:** rapid pushes, Dependabot PRs, or matrices create more work than expected.
3. **Duration:** a job hangs and holds runner capacity for too long.

## Three places settings live

| Control plane | What it governs | Flood control? |
| --- | --- | --- |
| [Actions permissions](settings/01-actions-permissions.md) | Which actions/reusable workflows may be sourced | Usually no; Disable actions stops all |
| [Spending limits](settings/02-spending-limits.md) | Billable overage | Yes for cost, not free-tier usage |
| [Workflow YAML](settings/03-workflow-yaml.md) | Triggers, concurrency, timeouts, and job conditions | Yes for workflow behavior |

## Four scripts

| Script | Purpose | State-changing? |
| --- | --- | --- |
| `scripts/stop-actions.sh` | Cancel live runs and disable active workflows | Yes |
| `scripts/find-fuse.sh` | Read run history for likely root-cause signatures | No |
| `scripts/add-guards.py` | Add workflow-level concurrency guards | Yes, local YAML only |
| `scripts/verify.sh` | Check visible guard coverage in local workflows | No |

## Quick response

```bash
./scripts/stop-actions.sh owner/repo
./scripts/find-fuse.sh owner/repo 200
python3 ./scripts/add-guards.py /path/to/repo
# Add per-job timeouts and appropriate bot guards after review.
./scripts/verify.sh /path/to/repo
```

Then set **Settings → Billing → Spending limits → Actions → $0**, fix the
specific fuse, and re-enable only one workflow at a time.

## Honest limits

The tools cannot inspect account billing settings, prove every branch of a
workflow's behavior, or predict unknown third-party/external trigger chains.
Passing `verify.sh` means the visible checks pass; it is evidence, not a
universal warranty.

## Requirements

GitHub CLI authenticated with suitable repository/workflow access, Bash 4+,
Python 3, Git, `grep`, and `awk`.

## License

MIT — see [LICENSE](LICENSE).
