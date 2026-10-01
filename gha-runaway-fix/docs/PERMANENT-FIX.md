# Layered remediation and its limits

## The defensible claim

A repository with a $0 Actions spending cap and workflows that pass this
repository's verifier has guards against the **known conditions checked here**:
parallel accumulation, missing visible timeouts, and unguarded visible bot pushes.
That is useful coverage, not a guarantee against all present or future failure modes.

## Control matrix

| Failure mode | Spending cap | Concurrency | Timeout | Bot guard |
| --- | --- | --- | --- | --- |
| Billable overage | Yes | No | No | No |
| Parallel accumulation | No | Yes | No | No |
| Hung job | No | No | Yes | No |
| Bot push loop | No | No | No | Yes |
| Free-tier minute drain | No | Limits overlap | Limits duration | Stops one loop type |

## Procedure

1. Contain immediate damage with `scripts/stop-actions.sh` or GitHub's disable action control.
2. Set the spending cap in **Settings → Billing → Spending limits → Actions → $0**.
3. Diagnose the event, actor, timing, and relevant workflow definition.
4. Add the concurrency guard with `scripts/add-guards.py` and review the diff.
5. Add `timeout-minutes` under each job.
6. Add `if: ${{ github.actor != 'github-actions[bot]' }}` to jobs that commit/push when that guard matches the workflow's intent.
7. Run `scripts/verify.sh` and repair reported gaps.
8. Re-enable one workflow at a time and watch the run history.

## Honest limits

The verifier uses static text checks; it cannot prove an `if:` guard belongs to
the exact job that pushes, cannot inspect an account's billing setting, and
cannot identify every external or third-party trigger chain. Organization policy,
new workflow files, and GitHub product changes can alter the risk profile.
