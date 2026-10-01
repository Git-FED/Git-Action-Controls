# Spending limits

> **Personal repository path:** Settings → Billing → Spending limits → Actions
>
> **Organization path:** Organization → Settings → Billing → Spending limits

A spending limit is GitHub's billing enforcement. Set the Actions limit to
**$0** to prevent billable overage from starting after included usage is
exhausted. This is an account or organization setting, not a YAML setting.

## What a $0 limit does

- Stops billable usage beyond the included quota.
- Cannot be bypassed by a workflow YAML change.
- Applies even if a loop or a future contributor recreates the same issue.

## What it does not do

- It does not preserve free-tier minutes; those can still be consumed.
- It does not cancel currently running jobs by itself.
- It does not identify the workflow or event that caused unexpected usage.
- It may be governed by an organization or enterprise billing policy.

## Why this matters

Use it as a cost backstop while investigating the actual fuse. The sustainable
repair still requires understanding triggers, concurrency, duration, and any
workflow that writes back to the repository.
