#--created: may 2026

#--NOTE changed (27 jul) to:
# field_id: sexy1
# sea_name: 24/25
# block: B1
# plot: 101 (but as a character!)
# trt_name; apmix

#--NOTE 7 Aug 2028
# I added the sexy 26/27 plot assignments created in 02_randomize_sexy1_randomly-assign-trts....
# Must run that first

library(readxl)
library(tidyverse)

rm(list = ls())


# 1. sexy1 24/25 -------------------------------------------------------------

#--handmade
d1a <-
  read_excel("data-raw/sexy1/01_keys/sexy1-2024_eukey.xlsx", skip = 5) |>
  select(
    block,
    plot,
    trt_name = trt_id) |>
  filter(!is.na(trt_name)) |>
  distinct()

#--sexy1, 24/25, B1
d1b <-
  d1a |>
  mutate(
    field_id = "sexy1",
    sea_name = "24/25",
    block = paste0("B", block),
    plot = as.character(plot))

d1c <-
  d1b |>
  select(field_id, sea_name, block, plot, trt_name)

#--final
d1 <- d1c

# 2. sexy1 26/27 -------------------------------------------------------------

#--made in 00code_sex1_randomly-assign...
d2a <-
  read_csv("data-raw/sexy1/01_keys/sexy1-2026-plot-assignments.csv") |>
  mutate(plot = as.character(plot))

#--final
d2 <- d2a

# done --------------------------------------------------------------------

sexy1_plotkey <-
  d1 |>
  bind_rows(d2) |>
  arrange(sea_name, block, plot)

usethis::use_data(sexy1_plotkey, overwrite = TRUE)

sexy1_plotkey %>%
  write_csv("inst/extdata/sexy1_plotkey.csv")
