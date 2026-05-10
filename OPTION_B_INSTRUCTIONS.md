# Option B — Companion repo for the PKNCA user guide

This document explains what is needed from the `humanpred` org to host the PKNCA user guide as a companion repository, mirroring how mrgsolve separates their [user guide](https://mrgsolve.org/user-guide/) from their [pkgdown site](https://mrgsolve.org/docs/).

---

## What Option B looks like

| Layer | Repo | Rendered URL |
|---|---|---|
| pkgdown function reference | `humanpred/pknca` (existing) | `https://humanpred.github.io/pknca/` |
| User guide (this book) | `humanpred/pknca-book` (new) | `https://humanpred.github.io/pknca-book/` |

The two sites link to each other: every chapter in the book has a "pkgdown reference" footer linking to `humanpred.github.io/pknca/reference/<function>.html`, and (optionally) the pkgdown navbar can link back to the book.

---

## Steps required from the humanpred org

### 1. Create the repo

Create a new public repository: **`humanpred/pknca-book`**

Transfer or mirror the current `TeunP/PKNCA.doc` repository into it, or create a fresh repo and push the contents of this book.

```bash
# From a local clone of TeunP/PKNCA.doc:
git remote add upstream git@github.com:humanpred/pknca-book.git
git push upstream main
```

### 2. Enable GitHub Pages

In `humanpred/pknca-book` → Settings → Pages:

- **Source:** GitHub Actions (not a branch)
- This allows the included `.github/workflows/book.yml` to deploy automatically on every push to `main`.

### 3. Verify the site URL in `_quarto.yml`

The `_quarto.yml` in this repo already sets:

```yaml
website:
  site-url: https://humanpred.github.io/pknca-book
```

If the final URL differs (e.g., a custom domain), update this value before the first deploy.

### 4. (Optional) Link back from the pkgdown site

In `humanpred/pknca`'s `_pkgdown.yml`, add a navbar link to the book:

```yaml
navbar:
  right:
    - text: "User Guide"
      href: https://humanpred.github.io/pknca-book/
```

This mirrors how mrgsolve's pkgdown site links to their user guide.

### 5. (Optional) Custom domain

If `humanpred` has a custom domain (e.g., `pknca.humanpred.com`), both sites can be served from it:

- pkgdown at `pknca.humanpred.com/`
- book at `pknca.humanpred.com/user-guide/`

This requires configuring the `CNAME` file and GitHub Pages custom domain in both repos. Update `site-url` in `_quarto.yml` and the navbar link in `_pkgdown.yml` accordingly.

---

## What is already done in this repo (no action needed)

- [x] `.github/workflows/book.yml` — renders with Quarto and deploys to GitHub Pages on push to `main`
- [x] `_quarto.yml` — `site-url` set, navbar links to pkgdown reference and pkgdown home
- [x] `index.qmd` — version badge shows the PKNCA version the book was built against (dynamic, updates on each render)
- [x] All 21 chapters — footer callout with pkgdown reference links for every relevant function

---

## Bug to file before or alongside the PR

During authoring, a bug was found: when `hl_method = "tobit"` is set via `PKNCAdata(options = list(hl_method = "tobit"))`, the `lloq` value from the `PKNCAconc` object is not wired through to `pk.calc.half.life()`, causing a `"Please report a bug"` stop inside that function. The workaround is to call `pk.calc.half.life()` directly with the `lloq` argument.

Please file this as a separate issue on `humanpred/pknca` before or alongside the PR, so it can be tracked independently.
