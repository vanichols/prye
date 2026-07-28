#--last updated 28 jul 2026

library(readxl)
library(tidyverse)
library(openxlsx2)

rm(list = ls())


# assign treatments when added --------------------------------------------


# 1A. fall 2026 (only run once) --------------------------------------------

#--fall 2026 treatments
trts_26f <-
  read_excel("data-raw/clim1/keys/treatment-key-v5.xlsx", skip = 5) |>
  filter(pcr_planting == "fall" & sea_name == "26/27") |>
  select(trt_nu, trt_name) |>
  mutate(random_id = 1:n())

# 1B. read in current plot assignments -------------------------------------

#--which plots do not have a treatment assigned yet?
#--make sure to read in the most up to date one...
open_plots <-
  read_excel("data-raw/clim1/keys/2026sp_plot-key.xlsx") |>
  filter(is.na(trt_nu))

new_plots <- NULL
block_vec <- c("b1", "b2", "b3", "b4")

for (i in seq_along(block_vec)) {

  dat <-
    open_plots |>
    select(-trt_nu, -trt_name) |>
    filter(block == block_vec[i]) |>
    mutate(nrow = 1:n()) |>
    sample_n(nrow(trts_26f), replace = FALSE) |>
    mutate(random_id = 1:n()) |>
    left_join(trts_26f)

  new_plots <- bind_rows(new_plots, dat)
}

d1b <-
  new_plots |>
  arrange(block, plot) |>
  select(-nrow, -random_id, -trt_nu)


# 1c. integrate them back into plots --------------------------------------

master_plots <- read_csv("inst/extdata/clim1_plotkey.csv")

static_plots <-
  master_plots |>
  filter(!(plot %in% d1b$plot))

d1c <-
  static_plots |>
  bind_rows(d1b) |>
  arrange(block, plot)

d1c |>
  write_xlsx("data-raw/clim1/keys/2026fa_plot-key.xlsx")
