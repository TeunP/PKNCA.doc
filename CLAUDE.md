# CLAUDE.md — PKNCA Documentation Project

## What This Is

A standalone Quarto documentation site for the PKNCA R package (CRAN v0.12.1).
Intended audience: Teun (personal reference), eventually shareable.

## Project Structure

```
PKNCA.doc/
  CLAUDE.md              # this file
  _quarto.yml            # site config and navigation
  index.qmd              # overview: what is NCA, what is PKNCA
  validate.R             # self-check script — run to verify all examples work
  user/
    workflow.qmd         # visual + textual workflow overview (Mermaid)
    intravascular.qmd    # IV worked examples covering all options
    extravascular.qmd    # EV/oral worked examples covering all options
  dev/
    function-deps.qmd    # interactive visNetwork dependency graph of NCA parameters
    architecture.qmd     # light overview of class system and internals
  _site/                 # rendered output (gitignored)
```

## How to Render

```r
# Install dependencies (once)
install.packages(c("PKNCA", "quarto", "visNetwork", "igraph", "dplyr", "ggplot2"))

# Render the full site
quarto::quarto_render(".")

# Live preview with auto-reload
quarto::quarto_preview(".")
```

Or from terminal:
```bash
cd /Users/teun/Desktop/PKNCA.doc
quarto render
quarto preview   # opens browser, live reloads on save
```

## Self-Check

Run `validate.R` to verify all key examples produce numerically correct output:

```r
source("validate.R")
```

All checks print PASS or FAIL with expected vs. actual values.

## Conventions

- Datasets: `datasets::Indometh` (IV) and `datasets::Theoph` (EV/oral)
- PKNCA version: CRAN 0.12.1
- Code chunks: `eval: true` — everything must run
- No `suppressWarnings()` hiding real issues — fix root causes
- Each page is self-contained: load packages at the top of every `.qmd`

## Adding Content

- New user topics → `user/` as a new `.qmd`, add to `_quarto.yml` sidebar
- New dev topics → `dev/` as a new `.qmd`, add to `_quarto.yml` sidebar
- Always run `source("validate.R")` and `quarto render` after changes to confirm nothing broke

## Depth Reminder

Developer docs are currently light (architecture overview + dependency graph).
Ask Teun when to expand: formalsmap system, writing custom parameter functions,
business rules, unit system internals.
