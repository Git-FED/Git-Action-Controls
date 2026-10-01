# Deployment

## GitHub Pages

Use the included `deploy.yml`, keep the production branch `main`, and enable
GitHub Pages with **GitHub Actions** as the source. The root `index.html` is the
entry point.

## Local

```bash
python3 -m http.server 8000
```

Open `http://localhost:8000/` or double-click `index.html`.
