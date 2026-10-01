# gha-emergency-kit

A practical emergency toolkit for GitHub Actions queues that are running away.

> It does **not** repair a root cause automatically. It helps you pause the
> situation, switch to controlled manual execution, inspect the workflows, and
> bring automation back one workflow at a time.

## Quick start

```bash
git clone https://github.com/YOU/gha-emergency-kit
cd gha-emergency-kit
./install.sh
cd /path/to/affected-repo
doctor.sh
stop-actions.sh
```

`stop-actions.sh` cancels active runs and disables active workflows. It does
not delete source code, workflow files, branches, issues, releases, or secrets.
While workflows are disabled, push, pull-request, schedule, and manual triggers
will not run. Re-enable only the workflow you are ready to inspect.

## The common causes

1. **Self-triggering loop** — a workflow pushes a commit which triggers itself.
2. **Runaway parallel work** — many pushes or matrix combinations run together.
3. **Hung job** — a command can run until GitHub's long default timeout.

## Commands

| Command | Purpose | Changes GitHub or files? |
| --- | --- | --- |
| `stop-actions.sh` | Cancel live runs and disable active workflows. | GitHub state |
| `manual-only.py` | Replace workflow triggers with `workflow_dispatch`. | Workflow YAML |
| `run-all.sh` | Dispatch all active manual workflows. | GitHub state |
| `run-one-by-one.sh` | Dispatch manual workflows sequentially and wait. | GitHub state |
| `add-guards.py` | Add top-level concurrency guards. | Workflow YAML |
| `audit.sh` | Inventory triggers, guards, and loop risk. | Read-only |
| `doctor.sh` | Check local prerequisites. | Read-only |

## Safe response sequence

1. Run `doctor.sh` from the affected repository.
2. Run `stop-actions.sh` only if immediate containment is required.
3. Inspect `docs/RUNBOOK.md` and run `audit.sh`.
4. Use `manual-only.py`, review `git diff`, and commit the controlled state.
5. Re-enable and manually test one workflow at a time.
6. Add concurrency, timeouts, and a bot guard where applicable before restoring automatic triggers.

## Requirements

- GitHub CLI (`gh`) authenticated with `repo` and `workflow` scopes
- Bash 4+, Python 3, Git, and `base64`

## Documentation

- [Emergency runbook](docs/RUNBOOK.md)
- [GitHub settings map](docs/GITHUB-SETTINGS.md)
- [Copy-paste recipes](docs/RECIPES.md)
- [FAQ](docs/FAQ.md)

## License

MIT — see [LICENSE](LICENSE).
