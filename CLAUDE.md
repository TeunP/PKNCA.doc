# CLAUDE.md — PKNCA Documentation Book

This file provides guidance to Claude Code when working in this repository.

## What This Is

A Quarto book documenting the [PKNCA](https://github.com/humanpred/pknca) R package (≥ 0.12.2).
Every function, option, and parameter is covered with runnable examples verified against live PKNCA output.

**Book repo:** https://github.com/humanpred/pknca-book  
**pkgdown site:** https://humanpred.github.io/pknca/  
**Rendered book:** https://humanpred.github.io/pknca-book/

## How to Render

```bash
quarto render        # full build → output in _book/
quarto preview       # live preview with auto-reload
```

```r
# Install dependencies (once)
install.packages(c("PKNCA", "dplyr", "ggplot2", "conflicted"))
```

## Project Structure

```
_quarto.yml              # book config: title, author, chapters, site-url, navbar
index.qmd                # introduction + What's new per version
user/                    # 19 User Guide chapters
dev/                     # 2 Developer Reference chapters
.github/workflows/book.yml  # CI: renders and deploys to GitHub Pages on push to main
_book/                   # rendered output (gitignored)
```

## Conventions

- **Datasets:** `datasets::Theoph` (extravascular) and `datasets::Indometh` (intravascular)
- **PKNCA version:** ≥ 0.12.2
- **Code chunks:** `eval: true` — every chunk must run without error
- **No `suppressWarnings()`** hiding real issues — fix root causes
- **Each page is self-contained:** load packages at the top of every `.qmd`
- **New features** are tagged with `(≥ X.Y.Z)` to indicate the minimum version

## Adding or Updating Content

See [CONTRIBUTING.md](CONTRIBUTING.md) for the full update workflow, including how to find what changed in a new PKNCA release, write and test examples, identify which pages to update, and verify the build.

- New user topics → add a `.qmd` to `user/` and register it in `_quarto.yml`
- New dev topics → add a `.qmd` to `dev/` and register it in `_quarto.yml`
- Always run `quarto render` after changes and check the console for errors
- Every chapter must end with a `:::callout-note` footer linking new functions to `https://humanpred.github.io/pknca/reference/<function>.html` — add links when introducing functions not yet in the footer
