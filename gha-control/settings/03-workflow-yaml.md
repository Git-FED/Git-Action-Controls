# Workflow YAML controls

GitHub has no dashboard switch for the controls below. They live in the
workflow file so behavior is reviewable and versioned with code.

## Manual-only mode

```yaml
on:
  workflow_dispatch:
```

Place this as the trigger block to allow intentional manual dispatch. It
removes automatic `push`, `pull_request`, and schedule triggers from that file.
Use it while diagnosing; restoring automatic triggers without fixing the fuse
will restore the original behavior.

## Ignore documentation-only pushes

```yaml
on:
  push:
    paths-ignore:
      - '**.md'
      - 'docs/**'
      - '.gitignore'
```

Place it under `on.push` only when those files genuinely do not affect the job.

## Cancel stale parallel work

```yaml
concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true
```

Place this at the workflow top level after the trigger block. It keeps the
newest run for a workflow/ref combination and cancels stale in-progress work.

## Cap job duration

```yaml
jobs:
  test:
    runs-on: ubuntu-latest
    timeout-minutes: 15
```

Place `timeout-minutes` inside each job that needs a ceiling. GitHub's default
can be much longer than a failed test or hung network call warrants.

## Guard a job that writes back

```yaml
jobs:
  release:
    if: ${{ github.actor != 'github-actions[bot]' }}
```

Place this at the job level when its steps can commit or push and the intended
policy is to avoid bot-triggered recursion. Review the job's event and actor
requirements before adding it; this is not a substitute for removing an
unneeded push.
