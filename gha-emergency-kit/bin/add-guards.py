#!/usr/bin/env python3
"""Add a workflow-level concurrency guard without touching jobs or steps.

Usage: python3 add-guards.py [path-to-repository]

This intentionally does not add timeout-minutes or bot guards: both are
job-specific decisions that must be reviewed by a human.
"""
from __future__ import annotations

import re
import sys
from pathlib import Path

repository = Path(sys.argv[1] if len(sys.argv) > 1 else ".").resolve()
workflow_dir = repository / ".github" / "workflows"
ON_BLOCK = re.compile(r"(?ms)^on\s*:.*?(?=^\S|\Z)")
TOP_LEVEL_CONCURRENCY = re.compile(r"(?m)^concurrency\s*:")
GUARD = (
    "concurrency:\n"
    "  group: ${{ github.workflow }}-${{ github.ref }}\n"
    "  cancel-in-progress: true\n\n"
)

if not workflow_dir.is_dir():
    print(f"No workflow directory found: {workflow_dir}", file=sys.stderr)
    raise SystemExit(1)

patched = 0
skipped = 0
for path in sorted((*workflow_dir.glob("*.yml"), *workflow_dir.glob("*.yaml"))):
    text = path.read_text(encoding="utf-8")
    if TOP_LEVEL_CONCURRENCY.search(text):
        print(f"skip (has concurrency): {path}")
        skipped += 1
        continue

    match = ON_BLOCK.search(text)
    if match is None:
        print(f"skip (no top-level on:): {path}")
        skipped += 1
        continue

    updated = text[:match.end()] + "\n" + GUARD + text[match.end():]
    path.write_text(updated.rstrip() + "\n", encoding="utf-8")
    print(f"patched: {path}")
    patched += 1

print(f"Patched {patched} workflow(s), skipped {skipped}.")
print("Review with: git diff .github/workflows/")
