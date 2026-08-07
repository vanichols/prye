# created: 27 may 2026
# purpose: Hold explicit descriptions of each of the seasons

#--want something simple
# just sea_id: sexy1_24/25
#      sea_name: 24/25
#      sea_description: Planting in fall of 2024, grain harvest August 2025, last cover crop biomass sample and frost in Oct 2025
#

library(readxl)
library(tidyverse)

rm(list = ls())

sexy1_seakey <-
  tribble(
    ~ sea_id,     ~sea_name,          ~sea_description,
    "sexy1_24/25",  "24/25",         "All treatments planted in fall of 2024, grain harvest August 2025, last cover crop biomass sample and frost in Oct 2025",
    "sexy1_25/26",    "25/26",         "(Reset year) Treatments over wintered, all treatments sprayed with herbicides in spring, oats no-till planted across plots, grain harvested in each plot summer 2026, straw removed",
    "sexy1_26/27",    "26/27",         "(Coming) All treatments planted in fall of 2026, grain harvest August 2027, last cover crop biomass sample and frost in Oct 2027",
  )

usethis::use_data(sexy1_seakey, overwrite = TRUE)

sexy1_seakey %>%
  write_csv("inst/extdata/sexy1_seakey.csv")
