# created 28 jul 2026
# purpose: keep track of season information

#--want something simple, follows sexy1 and sexy2 format
# just sea_id: sexy1_24/25
#      sea_name: 24/25
#      sea_description: Planting in fall of 2024, grain harvest August 2025, last cover crop biomass sample and frost in Oct 2025
#

library(readxl)
library(tidyverse)

rm(list = ls())

clim1_seakey <-
  tribble(
    ~ sea_id,     ~sea_name,          ~sea_description,
    "clim1_26/27",  "26/27",         "Treatments planted in either spring or fall of 2026, grain harvest August 2027",
  )

usethis::use_data(clim1_seakey, overwrite = TRUE)

clim1_seakey %>%
  write_csv("inst/extdata/clim1_seakey.csv")
