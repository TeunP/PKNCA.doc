# PKNCA docs — full mrgsolve-style setup for Claude Code

This file is a Claude Code instruction set. Open it in a Claude Code session inside the `humanpred/pknca` repo and say: **"Follow BILLDENNEY_SETUP.md"**. Claude will execute each step.

---

## What this builds

The same three-layer structure as mrgsolve.org:

| Layer | Repo | URL | Status |
|---|---|---|---|
| 1 — pkgdown function reference | `humanpred/pknca` (existing) | `humanpred.github.io/pknca/` | Already exists |
| 2 — Quarto user guide book | `humanpred/pknca-book` (new) | `humanpred.github.io/pknca-book/` | Needs repo setup |
| 3 — Hub landing page | `humanpred/pknca-site` (new) | `humanpred.github.io/pknca/` or custom domain | Needs building |

---

## Step 1 — Mirror the book repo

Create `humanpred/pknca-book` as a mirror of `TeunP/PKNCA.doc`:

```bash
# Clone the source book
git clone https://github.com/TeunP/PKNCA.doc.git pknca-book
cd pknca-book

# Create the new org repo (requires gh auth with humanpred org access)
gh repo create humanpred/pknca-book --public --description "PKNCA user guide — Quarto book"

# Push
git remote set-url origin https://github.com/humanpred/pknca-book.git
git push -u origin main
```

Then enable GitHub Pages on `humanpred/pknca-book`:
```bash
gh api repos/humanpred/pknca-book/pages \
  --method POST \
  -f build_type=workflow \
  -f source.branch=main
```

The book will auto-deploy via the included `.github/workflows/book.yml` on every push to `main`.

---

## Step 2 — Link the book from the pkgdown site

In `humanpred/pknca`, add a navbar entry to `_pkgdown.yml` pointing to the book:

```yaml
navbar:
  right:
    - text: "User Guide"
      href: https://humanpred.github.io/pknca-book/
```

Rebuild and redeploy the pkgdown site after this change.

---

## Step 3 — Build the hub landing page (layer 3)

This is what gives the full mrgsolve.org look: a Quarto *website* (not book) that acts as the top-level landing page with a navbar linking to all resources.

Create a new repo `humanpred/pknca-site` with the following structure:

```
_quarto.yml          # website config (not book)
index.qmd            # landing page
news.qmd             # changelog (mirrors NEWS.md from the package)
```

### `_quarto.yml`

```yaml
project:
  type: website
  output-dir: _site

website:
  title: "PKNCA"
  site-url: https://humanpred.github.io/pknca-site/
  navbar:
    left:
      - text: "User Guide"
        href: https://humanpred.github.io/pknca-book/
      - text: "Reference"
        href: https://humanpred.github.io/pknca/reference/index.html
      - text: "News"
        href: news.html
      - text: "Source"
        href: https://github.com/humanpred/pknca
    right:
      - icon: github
        href: https://github.com/humanpred/pknca

format:
  html:
    theme: cosmo
```

### `index.qmd`

A landing page introducing PKNCA, with prominent call-to-action buttons linking to the User Guide and Reference. Model it on mrgsolve.org — short intro, one-line install code, three buttons: Get Started, User Guide, Reference.

### GitHub Actions for the hub

Add `.github/workflows/site.yml`:

```yaml
name: Render and deploy site

on:
  push:
    branches: [main]
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: quarto-dev/quarto-actions/setup@v2
      - run: quarto render
      - uses: actions/upload-pages-artifact@v3
        with:
          path: _site

  deploy:
    needs: build
    runs-on: ubuntu-latest
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    steps:
      - uses: actions/deploy-pages@v4
        id: deployment
```

Enable GitHub Pages on `humanpred/pknca-site` → Source: GitHub Actions, then push to `main`.

---

## Step 4 — (Optional) Custom domain

If serving everything from a single custom domain (e.g. `pknca.humanpred.com`):

1. Configure DNS to point the domain to `humanpred.github.io`
2. Set custom domain in Settings → Pages for each repo
3. Update `site-url` in each `_quarto.yml` and `_pkgdown.yml` accordingly

Typical final URLs:
- `pknca.humanpred.com/` → hub landing page
- `pknca.humanpred.com/user-guide/` → book
- `pknca.humanpred.com/reference/` → pkgdown

---

## Summary of what Claude Code should do

1. Clone `TeunP/PKNCA.doc`, create `humanpred/pknca-book`, push, enable Pages
2. Edit `_pkgdown.yml` in `humanpred/pknca` to add the User Guide navbar link
3. Create `humanpred/pknca-site` with `_quarto.yml`, `index.qmd`, `news.qmd`, and the GitHub Actions workflow
4. Enable Pages on `humanpred/pknca-site`
5. Verify all three sites deploy successfully
