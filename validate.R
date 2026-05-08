# validate.R — self-check for PKNCA documentation examples
# Run: source("validate.R")  or  Rscript validate.R
#
# Checks that key documented examples produce numerically correct output.
# Prints PASS / FAIL for each check. Exit code 1 if any FAILs.

library(PKNCA)
library(dplyr)

n_pass <- 0L
n_fail <- 0L

check <- function(label, actual, expected, tol = 0.05) {
  # tol: relative tolerance (5%)
  ok <- isTRUE(all.equal(actual, expected, tolerance = tol, scale = abs(expected)))
  if (ok) {
    cat(sprintf("  PASS  %s  (%.4g)\n", label, actual))
    n_pass <<- n_pass + 1L
  } else {
    cat(sprintf("  FAIL  %s  expected ~%.4g, got %.4g\n", label, expected, actual))
    n_fail <<- n_fail + 1L
  }
}

cat("=== Intravascular (Indometh) ===\n")
{
  d_conc <- as.data.frame(Indometh)
  d_dose <- data.frame(Subject = unique(d_conc$Subject), dose = 25, time = 0)

  o_conc <- PKNCAconc(d_conc, conc ~ time | Subject)
  o_dose <- PKNCAdose(d_dose, dose ~ time | Subject, route = "intravascular")
  # Indometh: first sample is at t=0.25h (no t=0 measurement).
  # Use impute="start_conc0" to add conc=0 at t=0, enabling interval start=0.
  # Note: this slightly underestimates AUClast vs. C0 back-extrapolation.
  o_data <- PKNCAdata(o_conc, o_dose,
    intervals = data.frame(
      start = 0, end = Inf,
      auclast = TRUE, aucinf.obs = TRUE, half.life = TRUE,
      cmax = TRUE, cl.obs = TRUE
    ),
    impute = "start_conc0"
  )
  res <- pk.nca(o_data)
  df  <- as.data.frame(res)

  get_mean <- function(param) {
    mean(df$PPORRES[df$PPTESTCD == param], na.rm = TRUE)
  }

  # Reference values computed from Indometh with start_conc0 imputation:
  # AUClast ≈ 2.45, half-life ≈ 2.44 h (mean across 6 subjects), cmax ≈ 2.08
  check("IV: mean AUClast",   get_mean("auclast"),  2.45, tol = 0.10)
  check("IV: mean half.life", get_mean("half.life"), 2.44, tol = 0.20)
  check("IV: mean cmax",      get_mean("cmax"),      2.08, tol = 0.10)
  check("IV: n subjects",     nrow(df[df$PPTESTCD == "auclast", ]), 6, tol = 0)

  # cl.obs requires aucinf.obs which requires lambda.z — check it is computed
  cl_n <- sum(!is.na(df$PPORRES[df$PPTESTCD == "cl.obs"]))
  check("IV: cl.obs computed for all 6 subjects", cl_n, 6, tol = 0)
}

cat("\n=== Extravascular (Theoph) ===\n")
{
  d_conc <- as.data.frame(Theoph) |> rename(time = Time, subject = Subject)
  d_dose <- Theoph |> as.data.frame() |>
    group_by(Subject) |>
    summarise(dose = Dose[1] * Wt[1], .groups = "drop") |>
    rename(subject = Subject) |>
    mutate(time = 0)

  o_conc <- PKNCAconc(d_conc, conc ~ time | subject)
  o_dose <- PKNCAdose(d_dose, dose ~ time | subject, route = "extravascular")
  o_data <- PKNCAdata(o_conc, o_dose, intervals = data.frame(
    start = 0, end = Inf,
    cmax = TRUE, tmax = TRUE, auclast = TRUE,
    aucinf.obs = TRUE, half.life = TRUE, cl.obs = TRUE
  ))
  res <- pk.nca(o_data)
  df  <- as.data.frame(res)

  get_mean <- function(param) {
    mean(df$PPORRES[df$PPTESTCD == param], na.rm = TRUE)
  }

  # Reference values from Theoph dataset (well-characterised):
  # Cmax ≈ 8–10 mg/L, Tmax ≈ 1.5–2 h, AUClast ≈ 100–115 h·mg/L, t1/2 ≈ 7–9 h
  check("EV: mean cmax",      get_mean("cmax"),     9.0, tol = 0.15)
  check("EV: mean tmax",      get_mean("tmax"),     1.8, tol = 0.40)
  check("EV: mean auclast",   get_mean("auclast"), 105,  tol = 0.15)
  check("EV: mean half.life", get_mean("half.life"), 8.0, tol = 0.20)
  check("EV: n subjects",     nrow(df[df$PPTESTCD == "cmax", ]), 12, tol = 0)
}

cat("\n=== Options system ===\n")
{
  # Confirm PKNCA.options() returns expected defaults
  opts <- PKNCA.options()
  check("options: min.hl.points default",    opts$min.hl.points,    3,   tol = 0)
  check("options: max.aucinf.pext default",  opts$max.aucinf.pext,  20,  tol = 0)
  check("options: min.hl.r.squared default", opts$min.hl.r.squared, 0.9, tol = 0)
}

cat("\n=== Parameter registry ===\n")
{
  cols <- get.interval.cols()
  # Check key parameters are registered
  required_params <- c("auclast", "aucinf.obs", "half.life", "lambda.z",
                        "cmax", "tmax", "cl.obs", "vz.obs", "mrt.iv.last")
  for (p in required_params) {
    present <- p %in% names(cols)
    if (present) {
      cat(sprintf("  PASS  param registered: %s\n", p))
      n_pass <- n_pass + 1L
    } else {
      cat(sprintf("  FAIL  param NOT registered: %s\n", p))
      n_fail <- n_fail + 1L
    }
  }
}

cat(sprintf("\n--- Results: %d passed, %d failed ---\n", n_pass, n_fail))
if (n_fail > 0) {
  message(sprintf("%d check(s) FAILED", n_fail))
  quit(status = 1)
} else {
  message("All checks passed.")
}
