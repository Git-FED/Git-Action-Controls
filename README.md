# GitHub Actions Control Suite

This folder is a six-page, file://-compatible static site for the three-project
GitHub Actions Control Suite. It uses inline CSS and JavaScript in every HTML
file, relative links, no build step, an 18+ gate for payment embeds, and a
support page that loads provider resources only after age confirmation.

## Pages

- `index.html` — suite landing page and control map
- `support.html` — contribution and maintenance page with age-gated provider widgets
- `privacy.html` — static-site privacy notes
- `terms.html` — MIT/license and honest-claims page
- `accessibility.html` — keyboard, contrast, and reduced-motion notes
- `404.html` — project-specific not-found page

## Open locally

Double-click `index.html`, or run a local server:

```bash
python3 -m http.server 8000
```

Then open `http://localhost:8000/` from this directory.

## Publish with GitHub Pages

Put this folder at the root of a Pages repository, or configure the Pages
source to this directory in the repository workflow. All links are relative and
work from a static host or `file://`.

## Publish as a plain static site on Cloudflare Workers

For the folder contents at repository root, use:

```text
Build command: [blank]
Deploy command: npx wrangler deploy --assets=.
Root directory: /
Production branch: main
```

No package manager or runtime variable is required for this static site. If the
folder remains nested, set the assets directory to the nested folder instead.

## Visual direction

Daily-seed candidates considered:

- D1: Blueprint/technical drawing + dense newspaper + a red fuse line crossing every section.
- D2: Paper-and-ink letterpress + narrow long-form column + oversized marginal chapter numbers.
- D3: Utilitarian data dashboard + fixed split-screen halves + a live-looking incident console.

Chosen D1 because it least resembles a dark SaaS landing page. The signature
move is the single red fuse line: it appears in the hero diagram and as the
short red rule that enters each section. The site uses warm paper, ink, blue,
red, and ochre; hairline grids; a serif/sans/monospace contrast; and restrained
motion that disables under `prefers-reduced-motion`.

## External resources

The landing, privacy, terms, accessibility, and 404 pages do not require
external resources. `support.html` intentionally loads the supplied PayPal,
Stripe, Ko-fi, GitHub Sponsors, Buy Me a Coffee, NOWPayments, and Substack
provider widgets/links; the page remains readable if any provider is blocked or
unavailable. Replace or remove those integrations when publishing a fork.

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
