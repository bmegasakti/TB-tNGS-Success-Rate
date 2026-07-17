############################################################
# 01_logistic_regression.R
#
# Multivariable logistic regression analysis of factors
# associated with successful targeted next-generation
# sequencing (tNGS)
#
# Outcome:
#   Successful tNGS (Yes vs No)
#
# Predictors:
#   - AFB smear grade
#   - HIV status
#   - Sequencing platform
#
# Output:
#   Adjusted_OR_table.csv
############################################################

############################################################
## Load packages
############################################################

library(dplyr)
library(broom)

############################################################
## Import data
############################################################

df <- read.csv(
  "2026-07-15_AFB.csv",
  sep = ";",
  stringsAsFactors = FALSE,
  check.names = FALSE
)

############################################################
## Rename variables
############################################################

names(df)[names(df) == "Identifiable?"] <- "Identifiable"

############################################################
## Data cleaning
############################################################

df <- df %>%
  mutate(
    AFB = trimws(AFB),
    HIV = trimws(HIV),
    Platform = trimws(tNGS_platform),
    Success = trimws(Identifiable)
  )

############################################################
## Keep analysis cohort
############################################################

df <- df %>%
  filter(
    
    AFB %in% c(
      "Neg",
      "Scanty",
      "1+",
      "2+",
      "3+"
    ),
    
    HIV %in% c(
      "Negatif",
      "Positif"
    ),
    
    Platform %in% c(
      "ONT",
      "GS"
    ),
    
    Success %in% c(
      "Yes",
      "No"
    )
    
  )

############################################################
## Set reference categories
############################################################

df <- df %>%
  mutate(
    
    Success = factor(
      Success,
      levels = c("No", "Yes")
    ),
    
    AFB = factor(
      AFB,
      levels = c(
        "Neg",
        "Scanty",
        "1+",
        "2+",
        "3+"
      )
    ),
    
    HIV = factor(
      HIV,
      levels = c(
        "Negatif",
        "Positif"
      )
    ),
    
    Platform = factor(
      Platform,
      levels = c(
        "ONT",
        "GS"
      )
    )
    
  )

############################################################
## Descriptive checks
############################################################

cat("\nSample size:", nrow(df), "\n\n")

print(table(df$AFB))
print(table(df$HIV))
print(table(df$Platform))
print(table(df$Success))

############################################################
## Multivariable logistic regression
############################################################

fit <- glm(
  
  Success ~
    AFB +
    HIV +
    Platform,
  
  family = binomial,
  
  data = df
  
)

############################################################
## Model summary
############################################################

summary(fit)

############################################################
## Extract adjusted odds ratios
############################################################

results <- tidy(
  
  fit,
  
  exponentiate = TRUE,
  
  conf.int = TRUE
  
)

############################################################
## Publication-ready table
############################################################

OR_table <- results %>%
  
  filter(term != "(Intercept)") %>%
  
  mutate(
    
    Variable = c(
      
      "AFB Scanty vs Negative",
      
      "AFB 1+ vs Negative",
      
      "AFB 2+ vs Negative",
      
      "AFB 3+ vs Negative",
      
      "HIV Positive vs Negative",
      
      "GS vs ONT"
      
    )
    
  ) %>%
  
  transmute(
    
    Variable,
    
    aOR = round(estimate, 2),
    
    Lower95CI = round(conf.low, 2),
    
    Upper95CI = round(conf.high, 2),
    
    `95% CI` = paste0(
      round(conf.low, 2),
      "–",
      round(conf.high, 2)
    ),
    
    p.value = signif(p.value, 3)
    
  )

############################################################
## Display results
############################################################

print(OR_table)

############################################################
## Export results
############################################################

write.csv(
  
  OR_table,
  
  "Adjusted_OR_table.csv",
  
  row.names = FALSE
  
)

cat(
  "\nAdjusted odds ratio table exported as:\n",
  "Adjusted_OR_table.csv\n"
)

############################################################
# End of script
############################################################
############################################################
# Forest plot
# Multivariable logistic regression
############################################################

library(dplyr)
library(forestploter)
library(grid)

############################################################
# Logistic regression results
############################################################

OR_dt <- tibble::tribble(
  ~Variable, ~OR, ~Lower, ~Upper, ~P,
  "AFB Scanty vs Negative", 3.01, 2.45, 3.71, "<0.001",
  "AFB 1+ vs Negative",     5.78, 4.78, 7.02, "<0.001",
  "AFB 2+ vs Negative",     9.28, 7.22, 12.06, "<0.001",
  "AFB 3+ vs Negative",    11.90, 9.38, 15.21, "<0.001",
  "HIV Positive vs Negative", 0.88, 0.58, 1.35, "0.558",
  "GS vs ONT",              2.22, 1.89, 2.61, "<0.001"
)

############################################################
# Text for table
############################################################

OR_dt$`aOR (95% CI)` <-
  sprintf("%.2f (%.2f–%.2f)",
          OR_dt$OR,
          OR_dt$Lower,
          OR_dt$Upper)

## Blank column for forest plot
OR_dt$Forest <- paste(rep(" ", 25), collapse = "")

############################################################
# Table
############################################################

plot_table <- OR_dt[, c(
  "Variable",
  "Forest",
  "aOR (95% CI)",
  "P"
)]

colnames(plot_table) <- c(
  "Variable",
  "",
  "aOR (95% CI)",
  "p-value"
)

############################################################
# Forest plot
############################################################

p <- forest(
  
  plot_table,
  
  est = OR_dt$OR,
  
  lower = OR_dt$Lower,
  
  upper = OR_dt$Upper,
  
  ci_column = 2,
  
  ref_line = 1,
  
  x_trans = "log",
  
  xlim = c(0.5, 20),
  
  ticks_at = c(0.5, 1, 2, 5, 10, 20),
  
  sizes = 0.6
  
)

############################################################
# Draw
############################################################

grid.newpage()
grid.draw(p)

############################################################
# Save PDF
############################################################

pdf(
  "Forest_plot_tNGS_success.pdf",
  width = 10,
  height = 5
)

grid.draw(p)

dev.off()

############################################################
# Save PNG
############################################################

png(
  "Forest_plot_tNGS_success.png",
  width = 3200,
  height = 1800,
  res = 300
)

grid.draw(p)

dev.off()############################################################
# Forest plot
# Multivariable logistic regression
############################################################

library(dplyr)
library(forestploter)
library(grid)

############################################################
# Logistic regression results
############################################################

OR_dt <- tibble::tribble(
  ~Variable, ~OR, ~Lower, ~Upper, ~P,
  "AFB Scanty vs Negative", 3.01, 2.45, 3.71, "<0.001",
  "AFB 1+ vs Negative",     5.78, 4.78, 7.02, "<0.001",
  "AFB 2+ vs Negative",     9.28, 7.22, 12.06, "<0.001",
  "AFB 3+ vs Negative",    11.90, 9.38, 15.21, "<0.001",
  "HIV Positive vs Negative", 0.88, 0.58, 1.35, "0.558",
  "GS vs ONT",              2.22, 1.89, 2.61, "<0.001"
)

############################################################
# Text for table
############################################################

OR_dt$`aOR (95% CI)` <-
  sprintf("%.2f (%.2f–%.2f)",
          OR_dt$OR,
          OR_dt$Lower,
          OR_dt$Upper)

## Blank column for forest plot
OR_dt$Forest <- paste(rep(" ", 25), collapse = "")

############################################################
# Table
############################################################

plot_table <- OR_dt[, c(
  "Variable",
  "Forest",
  "aOR (95% CI)",
  "P"
)]

colnames(plot_table) <- c(
  "Variable",
  "",
  "aOR (95% CI)",
  "p-value"
)

############################################################
# Forest plot
############################################################

p <- forest(
  
  plot_table,
  
  est = OR_dt$OR,
  
  lower = OR_dt$Lower,
  
  upper = OR_dt$Upper,
  
  ci_column = 2,
  
  ref_line = 1,
  
  x_trans = "log",
  
  xlim = c(0.5, 20),
  
  ticks_at = c(0.5, 1, 2, 5, 10, 20),
  
  sizes = 0.6
  
)

############################################################
# Draw
############################################################

grid.newpage()
grid.draw(p)

############################################################
# Save PDF
############################################################

pdf(
  "Forest_plot_tNGS_success.pdf",
  width = 10,
  height = 5
)

grid.draw(p)

dev.off()

############################################################
# Save PNG
############################################################

png(
  "Forest_plot_tNGS_success.png",
  width = 3200,
  height = 1800,
  res = 300
)

grid.draw(p)

dev.off()