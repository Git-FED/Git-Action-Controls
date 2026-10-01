# FAQ

**Will this delete workflow files?**  No. `stop-actions.sh` disables workflows through the GitHub API; YAML tools modify only `.github/workflows/` and should be reviewed with Git.

**Will the kill switch stop manual runs too?**  Yes. Disabled workflows cannot be dispatched until re-enabled with `gh workflow enable <file>`.

**Does it affect source code?**  No command edits application source. `manual-only.py` and `add-guards.py` edit workflow YAML only.

**Does it pause Dependabot?**  No. Dependabot is separate. Its PRs may still be created, but disabled workflows will not run on them.

**Can changes be undone?**  Yes. Re-enable a workflow through `gh`, and restore YAML with Git after reviewing the diff.

**Why not just set Actions permissions?**  Apart from disabling Actions completely, permissions control allowed action sources, not trigger frequency or job duration.

**What scopes are needed?**  `gh` needs access appropriate for the repository, normally `repo` and `workflow` scopes.
