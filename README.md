# GitHub Actions Control Suite

# FEDpromptly GitHub Pages promotional build

A standalone, dark-first, animated promotional site for the GitHub Actions
Control Suite and the wider FED-OS ecosystem.

## Pages

`index.html`, `support.html`, `privacy.html`, `terms.html`,
`accessibility.html`, and `404.html` all work from `file://` and share:

- animated ambient backgrounds and provider-specific embed effects
- dark mode by default with a paper-mode toggle
- 18+ verification before payment/support embeds are revealed
- a compact signal-desk footer with all supplied contacts and destinations
- visible keyboard focus and reduced-motion support

## Run locally

```bash
python3 -m http.server 8000
```

Open `http://localhost:8000/`.

## Deploy

Enable GitHub Pages with GitHub Actions as the source. The included
`.github/workflows/deploy.yml` uploads the repository root. Leave the build
command blank; this is a plain HTML site.

`CNAME` is intentionally a placeholder. Replace it with a verified custom
hostname only when DNS and Pages configuration are ready.

## Social preview and favicon

- `social-image.png` is 1280×640 for repository social previews.
- `assets/images/favicon.svg` is the page favicon.

## Provider note

The support page uses the provider identifiers and public links supplied by the
project owner. No payment or subscription is automatically submitted.

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
