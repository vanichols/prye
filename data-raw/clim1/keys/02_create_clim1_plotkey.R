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


# fix the old plotkey, only run once --------------------------------------

trt_old <-
  read_excel("data-raw/clim1/keys/treatment-key-v1.xlsx", skip = 5) |>
  select(trt_nu, trt_id)

#--note: trt_id is old treatment name, its not what I want
trt_new <-
  read_excel("data-raw/clim1/keys/treatment-key-v5.xlsx", skip = 5) |>
  left_join(trt_old, by = "trt_nu") |>
  select(trt_nu, trt_name, trt_id) |>
  filter(!is.na(trt_name))

#--read in plot assignments to old trt names
pold1 <-
  read_excel("data-raw/clim1/keys/plot-key-v1-old.xlsx", skip = 0)

#--make the column names what I want the clean version to be
pold2 <-
  pold1 |>
  mutate(sea_name = "26/27",
         field_id = "clim1") |>
  select(field_id, sea_name, block, plot, trt_id)

pnew <-
  pold2 |>
  left_join(trt_new, by = "trt_id", relationship = "many-to-many") |>
  select(-trt_id)

#--there are many plots that still need to be randomly assigned



pold1 <-
  pold |>
  separate(trt_id, into = c("season", "trt_id", "row_width", "nitrogen"))


pold1

# 1. raw data -------------------------------------------------------------

#--clim1, handmade
d1 <-
  read_excel("data-raw/clim1/keys/treatment-key-v2.xlsx", skip = 5) |>
  select(
    block,
    plot,
    trt_name = trt_id) |>
  filter(!is.na(trt_name)) |>
  distinct()

#--sexy1, 24/25
d2 <-
  d1 |>
  mutate(
    plot_id = paste("sexy1", plot, sep = "_"),
    sea_id = paste("sexy1", "24/25", sep = "_"),
    block = paste0("B", block))

d3 <-
  d2 |>
  select(plot_id, sea_id, block, plot, trt_name)

# done --------------------------------------------------------------------

sexy1_plotkey <-
  d3 |>
  arrange(plot) |>
  mutate(plot = as.character(plot))

usethis::use_data(sexy1_plotkey, overwrite = TRUE)

sexy1_plotkey %>%
  write_csv("inst/extdata/sexy1_plotkey.csv")
