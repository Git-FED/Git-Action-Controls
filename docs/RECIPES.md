# Recipes

## Stop active work and disable workflows

```bash
/path/to/gha-emergency-kit/bin/stop-actions.sh owner/repo
```

## Convert workflows to manual-only mode

```bash
python3 /path/to/gha-emergency-kit/bin/manual-only.py /path/to/repo
git -C /path/to/repo diff .github/workflows/
```

## Dispatch every manual workflow deliberately

```bash
/path/to/gha-emergency-kit/bin/run-one-by-one.sh owner/repo main
```

## Add a concurrency guard

```bash
python3 /path/to/gha-emergency-kit/bin/add-guards.py /path/to/repo
git -C /path/to/repo diff .github/workflows/
```

## Skip documentation-only pushes

```yaml
on:
  push:
    paths-ignore:
      - '**.md'
      - 'docs/**'
      - '.gitignore'
```

## Stop a job that commits from retriggering itself

```yaml
jobs:
  release:
    if: ${{ github.actor != 'github-actions[bot]' }}
```

## Put a ceiling on a hung job

```yaml
jobs:
  test:
    runs-on: ubuntu-latest
    timeout-minutes: 15
```
