# Regeneration prompt: `scripts/add-guards.py`

You are generating **only** `scripts/add-guards.py` for the `gha-runaway-fix` repository.

## Repository mission
A focused, layered remediation kit for GitHub Actions loops, parallel accumulation, and hung jobs. It documents what its checks prove and what they cannot prove.

## Target requirements
Add only top-level concurrency after an on block; preserve all other YAML and state that job-level decisions are left to humans.

## Non-negotiable constraints
- Write direct, technical documentation or readable Bash/Python code as appropriate.
- Explain limits instead of promising a universal or permanent fix.
- Code must be copy-pasteable, deterministic, and safe to run twice where practical.
- Shell scripts that call the GitHub API use `set -uo pipefail`, never `set -e`.
- YAML-editing code must never modify anything outside `.github/workflows/`.
- Do not include telemetry, credentials, or unrelated dependencies.
- Return the complete content of the target file and nothing else.
