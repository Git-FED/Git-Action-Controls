# Where GitHub Actions controls live

| Want to… | Exact location or file | UI? |
| --- | --- | --- |
| Disable all Actions | Repository → Settings → Actions → General → Actions permissions | Yes |
| Disable one workflow | Actions → workflow → menu → Disable workflow | Yes |
| Limit stale parallel runs | Workflow YAML: `concurrency:` | No |
| Make a workflow manual-only | Workflow YAML: `on: workflow_dispatch:` | No |
| Cap billable overage | Settings → Billing → Spending limits → Actions → $0 | Yes |
| Limit a job duration | Workflow YAML: `timeout-minutes:` | No |
| Skip docs-only pushes | Workflow YAML: `paths-ignore:` | No |
| Break a bot push loop | Workflow YAML: job-level `if:` | No |
| Pause Dependabot | Insights → Dependency graph → Dependabot → Pause | Yes |

**Key point:** action-source permissions answer *which actions may be used*;
they do not control how frequently an existing workflow triggers. Concurrency,
triggers, timeouts, and bot guards are versioned in YAML because GitHub has no
dashboard switch for them.
