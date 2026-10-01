# Architecture decision record

## 2026-10 — Standalone static pages

Use self-contained HTML files with inline CSS and JavaScript so pages work when
opened directly from `file://` and can be published by GitHub Pages without a
build step. Keep a scaffold for future extracted assets under `assets/`.
