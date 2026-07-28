#--last updated 27 may 2026

#--want something simple
# just plot_id: sexy1_101
#      sea_id: sexy1_24/25
#      plot: 101
#      block: B1
#      trt_name: p

#--NOTE I think this should change (27 jul) to:
# field_id: sexy1
# sea_name: 24/25
# block: B1
# plot: 101
# trt_name; apmix


library(readxl)
library(tidyverse)

rm(list = ls())


# 1. raw data -------------------------------------------------------------

#--sexy1, handmade
d1 <-
  read_excel("data-raw/sexy1/keys/sexy1-2024_eukey.xlsx", skip = 5) |>
  select(
    block,
    plot,
    trt_name = trt_id) |>
  filter(!is.na(trt_name)) |>
  distinct()

#--sexy1, 24/25, B1
d2 <-
  d1 |>
  mutate(
    field_id = "sexy1",
    sea_name = "24/25",
    block = paste0("B", block))

d3 <-
  d2 |>
  select(field_id, sea_name, block, plot, trt_name)

# done --------------------------------------------------------------------

sexy1_plotkey <-
  d3 |>
  arrange(plot) |>
  mutate(plot = as.character(plot))

usethis::use_data(sexy1_plotkey, overwrite = TRUE)

sexy1_plotkey %>%
  write_csv("inst/extdata/sexy1_plotkey.csv")
