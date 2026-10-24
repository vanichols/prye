# created 28 july 2026
# purpose: randomly assign new treatments each year, but keep old treatments in place

library(readxl)
library(tidyverse)
library(openxlsx2)

rm(list = ls())


# Assign all treatment numbers to a plot, respecting what is already assigned --------
load("data/clim1_trtkey.rda")

#--which treatments alrady have a place?
assigned_trts <-
  read_excel("data-raw/clim1/00_keys/2026sp_plot-key.xlsx") |>
  filter(!is.na(trt_nu)) |>
  select(trt_nu) |>
  distinct() |>
  arrange()

unassigned_trts <-
  clim1_trtkey |>
  filter(!(trt_nu %in% assigned_trts$trt_nu)) |>
  select(trt_nu) |>
  distinct() |>
  arrange()


#--which plots do not have a treatment assigned yet?
open_plots <-
  read_excel("data-raw/clim1/00_keys/2026sp_plot-key.xlsx") |>
  filter(is.na(trt_nu))


# 1A. assign remaining trts (only run once) --------------------------------------------

#--fall 2026 treatments
trts_26f <-
  unassigned_trts |>
  mutate(random_id = 1:n())

# 1B. read in current plot assignments -------------------------------------

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

#--trt numbers randomly assigned to open plots
d1b <-
  new_plots |>
  arrange(block, plot) |>
  select(-nrow, -random_id)


# 1c. get already assigned plots in here --------------------------------------

already_assigned_plots <-
  read_excel("data-raw/clim1/00_keys/2026sp_plot-key.xlsx") |>
  filter(!is.na(trt_nu)) |>
  select(-trt_name)

d1c <-
  d1b |>
  bind_rows(already_assigned_plots) |>
  arrange(field_id, block, plot)

d1c |>
  write_csv("data-raw/clim1/00_keys/clim1-plot-trt-assignments.csv")
