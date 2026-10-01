# Regeneration prompt: `scripts/verify.sh`

You are generating **only** `scripts/verify.sh` for the `gha-control` repository.

## Repository mission
A complete, honest guide to the three places GitHub Actions controls live: Actions permissions, spending limits, and workflow YAML, with tools to diagnose, contain, patch, and verify known risk patterns.

## Target requirements
Implement deterministic static workflow checks that report a file-level OK/FAIL table and nonzero exit when any required visible guard is missing.

## Non-negotiable constraints
- Write direct, technical documentation or readable Bash/Python code as appropriate.
- Explain limits instead of promising a universal or permanent fix.
- Code must be copy-pasteable, deterministic, and safe to run twice where practical.
- Shell scripts that call the GitHub API use `set -uo pipefail`, never `set -e`.
- YAML-editing code must never modify anything outside `.github/workflows/`.
- Do not include telemetry, credentials, or unrelated dependencies.
- Return the complete content of the target file and nothing else.
