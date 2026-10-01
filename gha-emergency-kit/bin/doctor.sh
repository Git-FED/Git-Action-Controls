#!/usr/bin/env bash
# Check prerequisites without changing the repository.
set -uo pipefail

failed=0
check() {
  local label="$1"; shift
  if "$@" >/dev/null 2>&1; then
    printf '[ OK ] %s\n' "$label"
  else
    printf '[FAIL] %s\n' "$label"
    failed=1
  fi
}

check "gh installed" gh --version
check "gh authenticated" gh auth status
check "Bash 4+" bash -c "test \"\${BASH_VERSINFO[0]}\" -ge 4"
check "Python 3" python3 --version
check "git" git --version
check "base64" base64 --version
check "inside a git work tree" git rev-parse --is-inside-work-tree
check ".github/workflows exists" test -d .github/workflows

if [[ -d .github/workflows ]]; then
  shopt -s nullglob
  files=(.github/workflows/*.yml .github/workflows/*.yaml)
  printf '       workflows found: %d\n' "${#files[@]}"
fi

if [[ "$failed" -ne 0 ]]; then
  echo "Fix failed checks before running a state-changing command." >&2
  exit 1
fi
echo "All checks passed."
