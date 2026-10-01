# Regeneration prompt: `uninstall.sh`

You are generating **only** `uninstall.sh` for the `gha-emergency-kit` repository.

## Repository mission
A shareable emergency toolkit for pausing a runaway GitHub Actions situation, converting workflows to manual-only mode, and verifying each workflow deliberately.

## Target requirements
Remove only matching symlinks in ~/.local/bin that point to this repository's bin directory; never delete source files.

## Non-negotiable constraints
- Write direct, technical documentation or readable Bash/Python code as appropriate.
- Explain limits instead of promising a universal or permanent fix.
- Code must be copy-pasteable, deterministic, and safe to run twice where practical.
- Shell scripts that call the GitHub API use `set -uo pipefail`, never `set -e`.
- YAML-editing code must never modify anything outside `.github/workflows/`.
- Do not include telemetry, credentials, or unrelated dependencies.
- Return the complete content of the target file and nothing else.
