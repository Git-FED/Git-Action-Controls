# Causes of runaway Actions

## 1. Self-triggering loop

A workflow commits or pushes, and a `push` trigger starts the same workflow again.
**Symptom:** new `push` runs appear seconds apart, often under `github-actions[bot]`.
**Confirm:** inspect run actor and search the workflow for `git push` or `git commit`.
**Fix:** remove the push where possible or add a job-level bot guard.

## 2. Runaway parallel runs

Rapid commits or a large matrix can create multiple equivalent runs. **Symptom:**
several runs for the same workflow/ref queue or execute at once. **Fix:** add a
workflow-level concurrency group with `cancel-in-progress: true`.

## 3. Zombie jobs

A test or external call can hang. **Symptom:** one job stays running with no useful
progress. **Fix:** add `timeout-minutes` to every job with a value appropriate to
that job's expected duration.

## 4. Docs-only noise

A broad `push` trigger runs CI for changes that cannot affect the build. **Symptom:**
repeated successful runs for README or documentation commits. **Fix:** use
`paths-ignore` for documented non-build paths where that matches project policy.

## 5. Dependabot bursts

Many dependency PRs may open around the same time and each can trigger CI.
**Symptom:** `pull_request` runs with `dependabot[bot]` in a burst. **Fix:** pause
or limit Dependabot separately, or choose a policy for Dependabot CI.
