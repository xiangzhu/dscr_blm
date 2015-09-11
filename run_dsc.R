library(dscr)

dsc_blm = new_dsc("genomic_prediction","dsc_blm")

source("scenarios.R")
source("methods.R")
source("score.R")

res=run_dsc(dsc_blm)



