# tNGS Success Rate Analysis by AFB Smear Grade and HIV Status

## Overview

This script evaluates the success rate of targeted next-generation sequencing (tNGS) for *Mycobacterium tuberculosis* drug resistance profiling, stratified by:

- Acid-fast bacilli (AFB) smear grade
- HIV status
- Sequencing platform (Oxford Nanopore Technologies [ONT] and GeneStudio S5 [GS])

The analysis calculates the proportion of samples yielding an identifiable resistance profile and generates a publication-quality stacked horizontal bar plot.

---

## Input Data

**File**

```
2026-07-15_AFB.csv
```

**Required columns**

| Column | Description |
|---------|-------------|
| Sample_code | Sample identifier |
| AFB | AFB smear grade |
| HIV | HIV status |
| tNGS_platform | Sequencing platform (ONT or GS) |
| Identifiable? | Whether resistance profile was successfully identified (Yes/No) |

---

## Data Cleaning

The script:

- trims whitespace
- renames `Identifiable?` to `Identifiable`
- excludes samples with

  - AFB = `Not tested`
  - AFB = `No Data`
  - AFB = `POS`
  - HIV = `no data`

Only the following categories are retained.

### AFB

- Neg
- Scanty
- 1+
- 2+
- 3+

### HIV

- Negatif
- Positif

### Sequencing platform

- ONT
- GS

---

## Definition of Successful Testing

A sample is considered **successful** when

```
Identifiable = "Yes"
```

A sample is considered **unsuccessful** when

```
Identifiable = "No"
```

---

## Calculated Outcomes

For each platform and subgroup, the script computes

- total number of samples
- number of successful tests
- number of unsuccessful tests
- success rate
- unsuccessful rate

---

## Figure

The script produces a stacked horizontal bar plot showing

- ONT
- GS

Each platform is stratified by

- AFB negative
- AFB scanty
- AFB 1+
- AFB 2+
- AFB 3+
- HIV negative
- HIV positive

Colors

| Result | Color |
|---------|-------|
| Successful | #43aec4 |
| Unsuccessful | #bf5757 |

---

## Output

The figure is exported as

```
Success_rate_AFB_HIV.png
```

at

- width = 8 in
- height = 7 in
- resolution = 600 dpi

---

## R Packages

```r
library(tidyverse)
library(ggplot2)
library(dplyr)
library(tidyr)
library(scales)
```

---

## Reproducibility

The analysis is fully data-driven.

No proportions or sample sizes are entered manually. All counts, percentages, and labels are automatically calculated from the input dataset, ensuring that updates to the CSV file are reflected directly in the generated figure.
