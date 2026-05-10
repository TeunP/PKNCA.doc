# PKNCA Documentation Book

[![Render and deploy book](https://github.com/TeunP/PKNCA.doc/actions/workflows/book.yml/badge.svg)](https://github.com/TeunP/PKNCA.doc/actions/workflows/book.yml)

A comprehensive **Quarto book** documenting the [PKNCA](https://github.com/humanpred/pknca) R package (≥ 0.12.2) with runnable examples throughout. Every function, option, and parameter is verified against live PKNCA output.

**Live book:** https://teunp.github.io/PKNCA.doc/  
**Intended home (pending org setup):** https://humanpred.github.io/pknca-book/

## Build locally

```r
# Install PKNCA 0.12.2
remotes::install_github("humanpred/pknca")
```

```bash
git clone https://github.com/TeunP/PKNCA.doc
cd PKNCA.doc
quarto render
open _book/index.html
```

## Contents

### User Guide (19 chapters)

| Chapter | Topics |
|---|---|
| [Workflow](user/workflow.qmd) | PKNCAconc → PKNCAdose → PKNCAdata → pk.nca; all 21 options with defaults |
| [Interval selection & parameter catalogue](user/intervals.qmd) | Interval data frame structure; group matching; all 143 calculable parameters |
| [AUC types & integration methods](user/auc-methods.qmd) | auclast/aucall/aucinf; partial AUC; lin up/log down vs linear vs lin-log; aucabove; time_above; AUMC; cav.int |
| [Half-life & terminal phase](user/halflife.qmd) | Curve stripping; adj.r.squared.factor; quality filters; Tobit regression; lambda.z.corrxy |
| [Extravascular (oral/SC)](user/extravascular.qmd) | BLQ handling; imputation strategies; tmin; lag time; multiple peaks |
| [Intravascular (IV)](user/intravascular.qmd) | IV bolus NCA; C0 back-extrapolation; IV infusion with ceoi; MRT correction |
| [Multiple-dose / steady-state](user/multiple-dose.qmd) | deg.fluc; swing; PTR; Cav; tau detection |
| [Urine excretion](user/urine-excretion.qmd) | ae; fe; clr.*; volpk; ermax/ertmax/ertlst; clr.*.dn |
| [Sparse PK sampling](user/sparse.qmd) | sparse_auclast + SE + df; sparse AUMC; mrt/cl/kel.sparse.last |
| [Superposition](user/superposition.qmd) | Predicting multiple-dose profiles from single-dose data |
| [Time to steady state](user/tss.qmd) | pk.tss.monoexponential; pk.tss.stepwise.linear; pk.tss |
| [Post-processing](user/postprocessing.qmd) | exclude(); normalize(); 17 .dn parameters; PKNCA.set.summary; get_halflife_points |
| [Units](user/units.qmd) | pknca_units_table() S3 generic; PKNCAdata method; preferred units; conversions |
| [Imputation](user/imputation.qmd) | start_conc0; start_predose; start_cmin; custom imputation methods |
| [Dose-aware interpolation](user/dose-aware-interpolation.qmd) | interp.extrap.conc.dose; .dose AUCint variants |
| [Custom parameters](user/custom-parameters.qmd) | add.interval.col; registering new NCA parameters |
| [Utility functions](user/utilities.qmd) | geomean; geocv; clean.conc.*; assert_conc_time |
| [Regulatory & CDISC](user/regulatory.qmd) | PP domain column mapping; exclude → PPEXCLFL; summary() for CSR tables |
| [Validation & testing](user/validation.qmd) | testthat suite; version pinning; manual AUClast spot-check |

### Developer Reference (2 chapters)

| Chapter | Topics |
|---|---|
| [Function dependencies](dev/function-deps.qmd) | Parameter dependency graph |
| [Architecture](dev/architecture.qmd) | Internal structure of PKNCA |

## What's new in PKNCA 0.12.2

- **Tobit regression** for half-life — handles BLQ terminal-phase observations via censored likelihood
- **`normalize()` / `normalize_by_col()`** — normalize results by any column (body weight, BSA, etc.)
- **`tmin`** — time of minimum concentration; **`first.tmin`** option
- **Sparse AUMC** (`sparse_aumclast`, SE, df) and derived parameters (`mrt.sparse.last`, `cl.sparse.last`, `kel.sparse.last`)
- **New urine parameters**: `volpk`, `ermax`, `ertmax`, `ertlst`, `clr.last.dn`, `clr.obs.dn`, `clr.pred.dn`
- **`lambda.z.corrxy`** — correlation between time and log-concentration for the λz regression window
- **`pknca_units_table()`** now an S3 generic with a `PKNCAdata` method
- **`allow_partial_missing_units`** option

## Related

- PKNCA source: https://github.com/humanpred/pknca
- pkgdown reference: https://humanpred.github.io/pknca/reference/index.html
- CRAN: https://cran.r-project.org/package=PKNCA
- Discussion: [humanpred/pknca#541](https://github.com/humanpred/pknca/issues/541)
- Setup guide for org repo + hub site: [BUILDING_SETUP.md](BUILDING_SETUP.md)
