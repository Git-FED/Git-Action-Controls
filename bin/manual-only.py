#!/usr/bin/env python3
"""Convert workflows to manual-only by replacing their top-level on: block.

Usage: python3 manual-only.py [path-to-repository]
Only .github/workflows/*.yml and *.yaml are edited. Review the diff before
committing; use git to restore the original triggers when ready.
"""
from __future__ import annotations

import re
import sys
from pathlib import Path

repository = Path(sys.argv[1] if len(sys.argv) > 1 else ".").resolve()
workflow_dir = repository / ".github" / "workflows"
ON_BLOCK = re.compile(r"(?ms)^on\s*:.*?(?=^\S|\Z)")
replacement = "on:\n  workflow_dispatch:\n"

if not workflow_dir.is_dir():
    print(f"No workflow directory found: {workflow_dir}", file=sys.stderr)
    raise SystemExit(1)

patched = skipped = 0
for path in sorted((*workflow_dir.glob("*.yml"), *workflow_dir.glob("*.yaml"))):
    text = path.read_text(encoding="utf-8")
    match = ON_BLOCK.search(text)
    if match is None:
        print(f"skip (no top-level on:): {path}")
        skipped += 1
        continue
    updated = text[:match.start()] + replacement + text[match.end():]
    path.write_text(updated.rstrip() + "\n", encoding="utf-8")
    print(f"patched: {path}")
    patched += 1

print(f"Patched {patched} workflow(s), skipped {skipped}.")
print("Review with: git diff .github/workflows/")
