#--last updated 27 may 2026

#--want something simple
# just sea_id: eusun1_24/25
#      sea_name: 24/25
#      sea_description: etc.

library(readxl)
library(tidyverse)

rm(list = ls())

eusun1_seakey <-
  tribble(
    ~ sea_id,     ~sea_name,      ~sea_description,
    "eusun1_24/25",  "24/25",     "Perennial cereal rye planted in fall of 2024, first grain harvest August 2025",
    "eusun1_25/26",   "25/26",     "Regrowth of perennial cereal rye starting in fall 2025, second grain harvest August 2026"
  )

usethis::use_data(eusun1_seakey, overwrite = TRUE)

eusun1_seakey %>%
  write_csv("inst/extdata/eusun1_seakey.csv")
