# Actions permissions

> **Location:** Repository → Settings → Actions → General → Actions permissions

These controls decide **which actions or reusable workflows may be used**.
They do not decide how frequently an allowed workflow is triggered.

| Option | What it does | What it does not do | Flood relevance |
| --- | --- | --- | --- |
| Allow all actions and reusable workflows | Permits action sources from any allowed location. | Limit trigger frequency, duration, or concurrency. | None. |
| Disable actions | Hides the Actions tab and prevents workflows from running. | Find or repair the root cause. | Immediate, nuclear containment. |
| Allow Git-FED actions only | Restricts sources to repositories within the organization/enterprise. | Prevent a permitted workflow from looping. | Security control, not a throttle. |
| Allow Git-FED plus selected non-Git-FED sources | Applies an organization source allowlist plus approved external sources. | Cap runners, jobs, or events. | Security control, not a throttle. |
| Require a full commit SHA | Requires action references to use a full SHA. | Alter an existing workflow's trigger behavior. | Supply-chain control, not a throttle. |

`Git-FED` is the organization/enterprise placeholder shown by the relevant
GitHub UI; use the organization name displayed in your own settings.

## Workflow permissions

The same page controls whether `GITHUB_TOKEN` receives read or read/write
repository permissions and whether Actions may create or approve pull requests.
These settings affect what a workflow can do after it runs. They can reduce the
ability to push or open PRs, but they do not replace a workflow-level guard.

## Bottom line

These settings answer **“is this action allowed to exist?”** They do not answer
**“how often can this workflow fire?”** Use YAML triggers, concurrency,
timeouts, and job conditions for run behavior.
