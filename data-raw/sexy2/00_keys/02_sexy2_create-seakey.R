# created: 27 may 2026
# purpose: Hold explicit descriptions of each of the seasons

#--based on sexy1 code

library(readxl)
library(tidyverse)

rm(list = ls())

sexy2_seakey <-
  tribble(
    ~ sea_id,     ~sea_name,          ~sea_description,
    "sexy2_25/26",    "25/26",         "All treatments planted in fall of 2025, grain harvest August 2026, last cover crop biomass sample and frost in Oct 2026",
    "sexy2_26/27",    "26/27",         "(Coming) P and Pcc treatments were left in place from 25/26 season, the apmix, aprow, xapmix, xaprow were planted to A, P, Acc, or Pcc in fall 2026 with grain harvested in summer 2027, other plots were tilled in the spring and planted to oats"
  )

usethis::use_data(sexy2_seakey, overwrite = TRUE)

sexy2_seakey %>%
  write_csv("inst/extdata/sexy2_seakey.csv")
