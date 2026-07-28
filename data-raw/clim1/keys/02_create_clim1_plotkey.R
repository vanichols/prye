#--last updated 28 jul 2026


#--simple (see meta_plotkey for descriptions):
#     field_id: sexy1
#     sea_name: 24/25
#     block: B1
#     plot: 101
#     trt_name: apmix

library(readxl)
library(tidyverse)

rm(list = ls())

# 1. raw data -------------------------------------------------------------

#--this is created by 00_randomly assign plots to treatments
#--clim1, handmade, make sure to read in the most up-to-date one
d1 <-
  read_excel("data-raw/clim1/keys/2026fa_plot-key.xlsx")


# done --------------------------------------------------------------------

clim1_plotkey <-
  d1 |>
  arrange(plot) |>
  mutate(plot = as.character(plot))

usethis::use_data(clim1_plotkey, overwrite = TRUE)

clim1_plotkey %>%
  write_csv("inst/extdata/clim1_plotkey.csv")
