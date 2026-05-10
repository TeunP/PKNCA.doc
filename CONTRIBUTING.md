# Contributing to the PKNCA Documentation Book

This guide explains how to update the book when a new version of PKNCA is released.
Anyone — maintainers, users, or contributors — can follow this workflow.

**Book repo:** https://github.com/TeunP/PKNCA.doc  
**Package repo:** https://github.com/humanpred/pknca  
**Upstream issue:** https://github.com/humanpred/pknca/issues/541

---

## Prerequisites

- R (≥ 4.2)
- [Quarto](https://quarto.org/docs/get-started/) (≥ 1.4)
- The PKNCA package at the version you want to document:

```r
# From GitHub (pre-CRAN release)
remotes::install_github("humanpred/pknca")

# Or from CRAN
install.packages("PKNCA")

# Confirm
packageVersion("PKNCA")
```

- Clone the book:

```bash
git clone https://github.com/TeunP/PKNCA.doc
cd PKNCA.doc
```

---

## Update workflow

### Step 1 — Find what changed

Read the PKNCA changelog for the new version:

```r
news(package = "PKNCA")
```

Or read it on GitHub: https://github.com/humanpred/pknca/blob/main/NEWS.md

For each item, classify it:

| Type | Example |
|---|---|
| New NCA parameter | new `add.interval.col()` entry |
| New option | new key in `PKNCA.options()` |
| New function | e.g. `normalize()` in 0.12.2 |
| Changed behaviour | existing function works differently |
| Bug fix | may invalidate an existing example |

Cross-check the parameter count and options list:

```r
library(PKNCA)
length(get.interval.cols())   # total registered parameters — compare to previous version
names(get.interval.cols())    # full list
PKNCA.options()               # all options with current defaults
```

---

### Step 2 — Write and test examples first

Before editing any `.qmd` file, write a minimal working example in R and confirm it runs without error.

Most pages share this dataset setup — reuse it:

```r
library(PKNCA)
library(dplyr)

d_one  <- as.data.frame(Theoph) |>
  filter(Subject == "1") |>
  rename(time = Time, subject = Subject)

d_dose <- data.frame(subject = "1",
                     dose    = Theoph$Dose[1] * Theoph$Wt[1],
                     time    = 0)

o_conc <- PKNCAconc(d_one,  conc ~ time | subject)
o_dose <- PKNCAdose(d_dose, dose ~ time | subject, route = "extravascular")

# Request the new parameter
iv    <- data.frame(start = 0, end = Inf, new_param = TRUE)
o_nca <- pk.nca(PKNCAdata(o_conc, o_dose, intervals = iv))

as.data.frame(o_nca) |>
  filter(PPTESTCD == "new_param") |>
  select(PPTESTCD, PPORRES)
```

**Known gotchas:**

- **Tobit half-life** — `pk.nca()` does not wire `lloq` through to `pk.calc.half.life()`. Use `pk.calc.half.life()` directly and add a note in the docs.
- **Sparse AUMC** — only set `sparse_aumclast = TRUE`. Explicitly requesting `sparse_auc_se = TRUE` alongside it triggers an internal type error.
- **`normalize()`** — replaces the original parameters (does not append). To keep both, `bind_rows()` before and after.
- **New option defaults** — always verify with `PKNCA.options("option_name")` before documenting the default.

---

### Step 3 — Identify which pages to update

| Changed item | Page(s) to update |
|---|---|
| New NCA parameter | `user/intervals.qmd` (catalogue + count) + thematic page |
| New option | `user/workflow.qmd` (options table) |
| New post-processing function | `user/postprocessing.qmd` |
| New sparse parameter | `user/sparse.qmd` |
| New excretion parameter | `user/urine-excretion.qmd` |
| New units feature | `user/units.qmd` |
| New imputation method | `user/imputation.qmd` |
| New custom-parameter API | `dev/architecture.qmd` |
| Bug fix changing output | Every page whose example output changes |
| New version | `index.qmd` (What's new section) + `README.md` |

---

### Step 4 — Edit the documentation

- Add new sections or update existing ones in the relevant `.qmd` files.
- Tag new features with `(≥ X.Y.Z)` so readers know when they were introduced.
- Keep the shared dataset pattern consistent across pages.

---

### Step 5 — Render and verify

```bash
quarto render
```

- Watch for **red error output** in the console — chunks that error are flagged even though `execute: error: false` suppresses them in the HTML output.
- Fix the code, not the error suppression.

Then open the book and spot-check every updated page:

```bash
open _book/index.html
```

Confirm:
- Output matches expected values
- No unexpected `NA` results
- Warnings are expected (e.g., half-life not calculable for some subjects)

---

### Step 6 — Commit and push

```bash
git add -u
git commit -m "update docs for PKNCA vX.Y.Z"
git push
```

The `_book/` directory is in `.gitignore` — only source `.qmd` files are committed.

---

### Step 7 — Notify the maintainer

Post a comment on the upstream issue or open a new one:

**Issue:** https://github.com/humanpred/pknca/issues/541

Template:
> Updated the documentation book for PKNCA vX.Y.Z — covers [list new features].
> Book: https://github.com/TeunP/PKNCA.doc

---

## Quick checklist

```
[ ] Read NEWS.md / changelog for the new version
[ ] Install new version and confirm with packageVersion()
[ ] Compare parameter count: length(get.interval.cols())
[ ] Check new options: PKNCA.options()
[ ] Write and test each new example in R before editing .qmd files
[ ] Update index.qmd "What's new" section
[ ] Update README.md version highlights
[ ] Update user/workflow.qmd options table (if options changed)
[ ] Update user/intervals.qmd parameter count and catalogue
[ ] Update thematic pages (auc-methods, halflife, sparse, urine, etc.)
[ ] quarto render — zero errors in console
[ ] Spot-check _book/ in browser
[ ] git commit and push
[ ] Comment on humanpred/pknca#541
```

---

## Book structure

```
_quarto.yml          # book config (title, author, chapters)
index.qmd            # introduction + What's new
user/                # 19 User Guide chapters
  workflow.qmd       # PKNCAconc → PKNCAdose → PKNCAdata → pk.nca; all options
  intervals.qmd      # interval data frame; full parameter catalogue
  auc-methods.qmd    # AUC types; integration methods; AUMC; aucabove; time_above
  halflife.qmd       # λz regression; Tobit; quality filters; lambda.z.corrxy
  extravascular.qmd  # oral/SC; BLQ; tmin; lag time
  intravascular.qmd  # IV bolus; C0; IV infusion; ceoi; MRT
  multiple-dose.qmd  # steady-state parameters; tau detection
  urine-excretion.qmd# ae; fe; clr; volpk; ermax; ertmax; ertlst; clr.*.dn
  sparse.qmd         # sparse_auclast; sparse AUMC; derived sparse params
  superposition.qmd  # predicting multiple-dose from single-dose
  tss.qmd            # time to steady state
  postprocessing.qmd # exclude(); normalize(); .dn parameters; PKNCA.set.summary
  units.qmd          # pknca_units_table(); preferred units; conversions
  imputation.qmd     # built-in imputation methods; custom methods
  dose-aware-interpolation.qmd  # interp.extrap.conc.dose; .dose AUCint variants
  custom-parameters.qmd         # add.interval.col(); registering new parameters
  utilities.qmd      # geomean; geocv; clean.conc.*; assert_conc_time
  regulatory.qmd     # PP domain; PPEXCLFL; summary() for CSR tables
  validation.qmd     # testthat suite; version pinning; spot-checks
dev/                 # Developer Reference
  function-deps.qmd  # parameter dependency graph
  architecture.qmd   # class hierarchy; interval column system; formalsmap
```
