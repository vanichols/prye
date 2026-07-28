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


# fix the old plotkey, only run once --------------------------------------
#
# trt_old <-
#   read_excel("data-raw/clim1/keys/treatment-key-v1.xlsx", skip = 5) |>
#   select(trt_nu, trt_id)
#
# #--note: trt_id is old treatment name, its not what I want
# trt_new <-
#   read_excel("data-raw/clim1/keys/treatment-key-v5.xlsx", skip = 5) |>
#   left_join(trt_old, by = "trt_nu") |>
#   select(trt_nu, trt_name, trt_id) |>
#   filter(!is.na(trt_name))
#
# #--read in plot assignments to old trt names
# pold1 <-
#   read_excel("data-raw/clim1/keys/plot-key-v1-old.xlsx", skip = 0)
#
# #--make the column names what I want the clean version to be
# pold2 <-
#   pold1 |>
#   mutate(sea_name = "26/27",
#          field_id = "clim1") |>
#   select(field_id, sea_name, block, plot, trt_id)
#
# pnew <-
#   pold2 |>
#   left_join(trt_new, by = "trt_id", relationship = "many-to-many") |>
#   select(-trt_id)
#
# #--there are many plots that still need to be randomly assigned,
# #--including the fall ones
#
# pnew1 <-
#   pnew |>
#   mutate(trt_name = ifelse(trt_nu > 6, NA, trt_name),
#          trt_nu = ifelse(trt_nu >6, NA, trt_nu))
#
# #--indicate where the practice plots are
# pnew2 <-
#   pnew1 |>
#   mutate(trt_name = case_when(
#     plot %in% c(101, 153, 201, 253, 301, 353, 401, 453) ~ "PRACTICE PLOT",
#     TRUE ~ trt_name
#   )) |>
#   mutate(trt_nu = ifelse(trt_name == "PRACTICE PLOT", 0, trt_nu))
#
# pnew2 |>
#   write_xlsx("data-raw/clim1/keys/plot-key-v2.xlsx")


# assign treatments when added --------------------------------------------

#--fall 2026 treatments
trts_26f <-
  read_excel("data-raw/clim1/keys/treatment-key-v5.xlsx", skip = 5) |>
  filter(pcr_planting == "fall" & sea_name == "26/27") |>
  select(trt_nu, trt_name) |>
  mutate(random_id = 1:n())

#--is this correct?
#--seems right
assigned_plots <-
  read_excel("data-raw/clim1/keys/plot-key-v2.xlsx") |>
  filter(!is.na(trt_nu))


#--which plots do not have a treatment assigned yet?
open_plots <-
  read_excel("data-raw/clim1/keys/plot-key-v2.xlsx") |>
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

new_plots |>
  arrange(block, plot) |>
  select(-nrow, -random_id)

#--need to finish...
