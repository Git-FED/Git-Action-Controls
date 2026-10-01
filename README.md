# GitHub Actions Control Suite

This archive contains **three independent repositories** reconstructed from the
supplied specification. Each has a distinct scope and can be copied into its
own Git repository without depending on the others.

| Project | Scope | Best use |
| --- | --- | --- |
| `gha-emergency-kit` | Broad operational toolkit with installation helpers, manual-only mode, dispatch helpers, audit/doctor scripts, and contributor templates. | A reusable support toolkit. |
| `gha-runaway-fix` | Focused layered remediation kit with a confirmation-gated restore helper. | A compact repository centered on safeguards and their limits. |
| `gha-control` | Final comprehensive control-plane guide: permissions, billing, workflow YAML, root-cause diagnostics, and verification. | A public documentation-plus-tools repository. |

## Standalone GitHub Pages site

The archive also includes [`github-actions-control-suite-site/`](github-actions-control-suite-site/),
a six-page, file://-compatible landing site with inline CSS/JavaScript, relative
navigation, theme persistence, responsive layouts, and reduced-motion support.
Open [`index.html`](github-actions-control-suite-site/index.html) directly or
publish that folder as the root of a GitHub Pages repository. The site uses the
actual project names, scripts, safeguards, and honest limitations from the suite.

The [`my-portfolio/`](my-portfolio/) folder is a publish-ready promotional
repository scaffold with GitHub Pages deployment workflow, funding configuration,
social preview image, favicon, component/data extension points, project docs,
and the same dark animated pages. Payment/support embeds are deferred behind an
18+ age confirmation and provider scripts load only after that confirmation.

All three projects deliberately distinguish **containment** from **root-cause
repair**. Review any state-changing script before use, keep credentials out of
source control, and test against a non-production repository before relying on
it during an incident.
