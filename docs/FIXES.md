# Fixes

## Stop active workflow runs

```bash
./scripts/stop-actions.sh owner/repo
```

## Inspect the likely fuse

```bash
./scripts/find-fuse.sh owner/repo 200
```

## Add concurrency to every workflow

```bash
python3 ./scripts/add-guards.py /path/to/repo
git -C /path/to/repo diff .github/workflows/
```

## Add a job timeout

```yaml
timeout-minutes: 15
```

## Guard a job that pushes commits

```yaml
if: ${{ github.actor != 'github-actions[bot]' }}
```

## Skip documentation-only pushes

```yaml
paths-ignore:
  - '**.md'
  - 'docs/**'
  - '.gitignore'
```

## Use temporary manual-only mode

```yaml
on:
  workflow_dispatch:
```

## Re-enable a single workflow

```bash
gh workflow enable ci.yml --repo owner/repo
gh workflow run ci.yml --repo owner/repo --ref main
```

## Verify visible guard coverage

```bash
./scripts/verify.sh /path/to/repo
```
