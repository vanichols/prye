#--last updated 28 jul 2026


#--simple (see meta_plotkey for descriptions):
#     field_id: sexy1
#     sea_name: 24/25
#     block: B1
#     plot: 101
#     trt_name: apmix

library(readxl)
library(tidyverse)
library(openxlsx2)

rm(list = ls())

# 1. raw data -------------------------------------------------------------

#--this is created by 00_randomly assign plots to treatments
d1 <-
  read_csv("data-raw/clim1/00_keys/clim1-plot-trt-assignments.csv")

#--trt_names assigned to trt_nu
#--make sure to read in the most recent one!!
d2 <-
  read_excel("data-raw/clim1/00_keys/running-treatment-key.xlsx", skip = 5) |>
  select(trt_nu, trt_name) |>
  add_row(trt_nu = 0, trt_name = "PRACTICE")


# combine -----------------------------------------------------------------

d3 <-
  d1  |>
  left_join(d2)

# done --------------------------------------------------------------------

clim1_plotkey <-
  d3 |>
  arrange(plot) |>
  mutate(plot = as.character(plot))

usethis::use_data(clim1_plotkey, overwrite = TRUE)

clim1_plotkey %>%
  write_csv("inst/extdata/clim1_plotkey.csv")

clim1_plotkey %>%
  write_xlsx("inst/extdata/EXCELclim1_plotkey.xlsx")
