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





d1 <-
  d |>
  separate(sample_id, into = c("env_key", "plot_id", "sampletype_id"), sep = "-") |>
  filter(sampletype_id != "A") |>
  select(-sample_desc) |>
  pivot_wider(names_from = sampletype_id, values_from = weight_in_g) |>
  mutate(pct_ergot_by_weight = B1/(B1+B2)*100)


d1 |>
  ggplot(aes(loc_id, pct_ergot_by_weight)) +
  geom_point()

#--get treatments for figure
d1 |>
  left_join(op_plotkey) |>
  left_join(op_trtkey) |>
  ggplot(aes(crop_id, pct_ergot_by_weight)) +
  geom_point() +
  facet_wrap(~loc_id)

#--can we look at it as a percentage of kernals? using tkw_?


#--so weight of ergot per 1000 kernals is about the same
#--there are more kernals per unit weight, so as a pct of kernals, ergot will result in a raw value being higher
d1 |>
  left_join(op_plotkey) |>
  left_join(op_trtkey) |>
  left_join(
    op_yields |>
      filter(name == "tkw_g")
  ) |>
  mutate(B2_kernals = B2 / value) |>
  select(B2_kernals, everything()) |>
  mutate(grams_ergot_per_1000kernals = B1/B2_kernals) |>
  ggplot(aes(crop_id, grams_ergot_per_1000kernals)) +
  geom_point() +
  facet_wrap(~loc_id)

