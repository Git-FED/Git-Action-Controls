# GitHub Actions Control Suite — standalone GitHub Pages site

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
