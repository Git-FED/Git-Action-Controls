# Copy-paste fixes

## Emergency containment

```bash
./scripts/stop-actions.sh owner/repo
```

## Add concurrency

```yaml
concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true
```

## Add a timeout to a job

```yaml
jobs:
  test:
    runs-on: ubuntu-latest
    timeout-minutes: 15
```

## Guard a job that pushes commits

```yaml
jobs:
  release:
    if: ${{ github.actor != 'github-actions[bot]' }}
```

## Ignore documentation-only pushes

```yaml
on:
  push:
    paths-ignore:
      - '**.md'
      - 'docs/**'
      - '.gitignore'
```

## Manual-only diagnostic mode

```yaml
on:
  workflow_dispatch:
```

## Verify declared safeguards

```bash
./scripts/verify.sh /path/to/repo
```
