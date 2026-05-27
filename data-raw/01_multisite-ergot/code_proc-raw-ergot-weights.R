#--cecilie's data taken from the o-drive 27 may 2026

rm(list = ls())

library(tidyverse)
library(readxl)


#--desired format:

#--sea, field, block, plot, trt, resp_type, resp_value, resp_units

f <-
  read_excel("data-raw/01_multisite-ergot/Ergot weight flakkebjerg - SEXY1.xlsx") |>
  janitor::clean_names() |>
  mutate(plot_id = as.character(plot_id))

e <-
  read_excel("data-raw/01_multisite-ergot/Ergot weight flakkebjerg - EUSUN1.xlsx") |>
  janitor::clean_names()


d <-
  f |>
  bind_rows(e)


# manipulate --------------------------------------------------------------

d1 <-
  d |>
  rename(sea_name = season_id,
         field_id = loc_id,
         plot = plot_id,
         sample_type = sample_desc,
         value = weight_in_g) |>
  mutate(unit = "weight in grams")


# create the plot_id and sea_id to merge with plotkey --------------------------------------------

d2 <-
  d1 |>
  mutate(plot_id = paste(field_id, plot, sep = "_"),
         sea_id = paste(field_id, sea_name, sep = "_"))

#--get treatment names
load("data/sexy1_plotkey.rda")
load("data/eusun1_plotkey.rda")

plotkey <-
  sexy1_plotkey |>
  bind_rows(eusun1_plotkey)

d3 <-
  d2 |>
  left_join(plotkey)



# add location so it is clear ---------------------------------------------

load("data/prye_fieldkey.rda")

d4 <-
  d3 |>
  left_join(prye_fieldkey)

#--clean up
d5 <-
  d4 |>
  select(
    field_place, field_lat, field_lon, field_country,
    sea_name, field_id, block, plot, trt_name, sample_id, sample_type, value, unit)


prye_ergot <- d5

usethis::use_data(prye_ergot, overwrite = TRUE)

prye_ergot |>
  write_csv("inst/extdata/prye_ergot.csv")
