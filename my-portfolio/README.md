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
