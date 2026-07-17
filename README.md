# tNGS Success Rate and Multivariable Logistic Regression Analysis

## Overview

This repository contains the R scripts used to evaluate the performance of targeted next-generation sequencing (tNGS) for tuberculosis drug resistance testing.

The analyses include:

1. Success rate of tNGS stratified by AFB smear grade, HIV status, and sequencing platform.
2. Multivariable logistic regression to identify factors independently associated with successful tNGS.
3. Forest plot visualization of adjusted odds ratios (aORs).

---

# Study Objective

To evaluate whether successful tNGS testing is associated with:

- Acid-fast bacilli (AFB) smear grade
- HIV status
- Sequencing platform

---

# Input Data

```
2026-07-15_AFB.csv
```

Required variables

| Variable | Description |
|-----------|-------------|
| Sample_code | Sample identifier |
| AFB | AFB smear grade |
| HIV | HIV status |
| tNGS_platform | Sequencing platform (ONT or GS) |
| Identifiable? | Successful resistance identification (Yes/No) |

---

# Data Cleaning

The scripts perform the following preprocessing steps:

- Rename `Identifiable?` to `Identifiable`
- Trim leading and trailing whitespace
- Create:
  - `Platform`
  - `Success`
- Restrict analyses to

### AFB

- Negative
- Scanty
- 1+
- 2+
- 3+

### HIV

- Negative
- Positive

### Platform

- ONT
- GS

Samples with unavailable AFB grading, HIV status, or sequencing outcome are excluded.

---

# Analysis 1

## Success Rate by AFB Smear Grade and HIV Status

### Objective

To compare the proportion of successful tNGS tests across

- AFB smear grade
- HIV status
- sequencing platform

### Outcome

Successful tNGS

```
Yes
```

versus

```
No
```

### Output

Publication-quality stacked horizontal bar plot

```
Success_rate_AFB_HIV.png
```

The figure displays

- ONT
- GS

stratified by

- AFB negative
- AFB scanty
- AFB 1+
- AFB 2+
- AFB 3+
- HIV negative
- HIV positive

---

# Analysis 2

## Multivariable Logistic Regression

### Objective

To determine factors independently associated with successful tNGS.

### Outcome

Successful tNGS

```
Yes
```

versus

```
No
```

### Independent variables

- AFB smear grade
- HIV status
- Sequencing platform

### Reference categories

| Variable | Reference |
|-----------|-----------|
| AFB | Negative |
| HIV | Negative |
| Platform | ONT |

The model estimates adjusted odds ratios (aORs) with 95% confidence intervals.

---

# Interpretation

An adjusted odds ratio (aOR)

- greater than 1 indicates higher odds of successful tNGS
- less than 1 indicates lower odds of successful tNGS
- equal to 1 indicates no association

All estimates are adjusted for the other variables included in the regression model.

---

# Outputs

The logistic regression exports

```
Adjusted_OR_table.csv
```

containing

- Variable
- Adjusted odds ratio (aOR)
- Lower 95% confidence interval
- Upper 95% confidence interval
- 95% confidence interval
- p-value

---

# Forest Plot

The adjusted odds ratios are visualized using a logarithmic forest plot.

Outputs

```
Forest_plot_tNGS_success.pdf
```

and

```
Forest_plot_tNGS_success.png
```

The figure displays

- adjusted odds ratio
- 95% confidence interval
- p-value

for

- AFB Scanty vs Negative
- AFB 1+ vs Negative
- AFB 2+ vs Negative
- AFB 3+ vs Negative
- HIV Positive vs Negative
- GS vs ONT

---

# Statistical Methods

Descriptive analysis

- Counts
- Proportions

Regression analysis

- Multivariable logistic regression

Model

```
Success ~ AFB + HIV + Platform
```

Outputs

- Adjusted odds ratio (aOR)
- 95% confidence interval
- p-value

---

# R Packages

```r
library(tidyverse)
library(dplyr)
library(broom)
library(ggplot2)
library(forestploter)
library(grid)
```

---

# Repository Structure

```
.
├── data
│   └── 2026-07-15_AFB.csv
│
├── scripts
│   ├── 01_success_rate_plot.R
│   ├── 02_logistic_regression.R
│   └── 03_forest_plot.R
│
├── results
│   ├── Success_rate_AFB_HIV.png
│   ├── Adjusted_OR_table.csv
│   ├── Forest_plot_tNGS_success.pdf
│   └── Forest_plot_tNGS_success.png
│
└── README.md
```

---

# Citation

If these scripts contribute to published work, please cite the associated manuscript.

---

# Author

Brahmastra Megasakti

UC Berkeley School of Public Health

Master of Public Health (Infectious Diseases and Vaccinology)

2026
