# created           july 2026
# purpose:          get all grain yields in one place for sexy1
# last updated:

library(tidyverse)

rm(list = ls())

#--doesn't hold it's character for plot, ok...
sexy1_plotkey <-
  read_csv("inst/extdata/sexy1_plotkey.csv")

#--pulled from emma's pkg on 4 aug 2026
load("data-raw/sexy1/fallbio/cc_biomass.rda")

#--field_id
#--sea_name
#--block
#--plot
#--trt_name

# 1. 2025 fall biomass samplings ----------------------------------------------------------

d1 <-
  cc_biomass |>
  mutate(across(where(is.factor), as.character)) |>
  mutate(field_id = "sexy1",
         sea_name = "24/25",
         trt_name = trt_id,
         plot = as.numeric(plot))

d2 <-
  d1 |>
  select(-block) |>
  left_join(sexy1_plotkey |> select(plot, block))

d3 <-
  d2 |>
  select(field_id, sea_name, trt_name, block, plot,
         sampledate_id, #--some samplings were spread over two days, Emma is very precise
         sampledate_ymd = sample_date,
         subsample_id,
         samplearea_m2,
         species_short,
         biomass_g = wholeplant_g,
         weed_pres) #--I'm not sure what weed_pres is

#--take the minimum date at every sampling point
d4 <-
  d3 |>
  group_by(sampledate_id) |>
  mutate(sampledate_ymd2 = min(sampledate_ymd))


d5 <-
  d4 |>
  select(field_id, sea_name, trt_name, block, plot,
         sampledate_ymd2,
         subsample_id,
         samplearea_m2,
         biomass_cat = species_short,
         biomass_g,
         weed_pres)

#--if biomass_cat is na, make it 'all'
d6 <-
  d5 |>
  mutate(biomass_cat = ifelse(is.na(biomass_cat), "all", biomass_cat))

#--change to biomass_kgha
d7 <-
  d6 |>
  group_by(field_id, sea_name, trt_name, block, plot, sampledate_ymd2, biomass_cat) |>
  summarise(samplearea_m2 = mean(samplearea_m2, na.rm = T),
            biomass_g = mean(biomass_g, na.rm = T)) |>
  mutate(biomass_kgha = (biomass_g / 1000) / (samplearea_m2 /10000)) |>
  select(-samplearea_m2, -biomass_g)

#--arrange it, does it make sense?
d7 |>
  arrange(trt_name, block, plot, sampledate_ymd2, biomass_cat)

#--change columns to match other data files
d8 <-
  d7 |>
  mutate(data_type = "fallbio_kgha") |>
  rename(value  = biomass_kgha) |>
  select(field_id, sea_name, trt_name, block, plot,
         sampledate_ymd2,
         data_type,
         biomass_cat,
         value)


# 9. weedbiomass -------------------------------------------------------------

load("data-raw/sexy1/fallbio/weedbiomass_bulked.rda")

d9 <-
  weedbiomass_bulked |>
  mutate(across(where(is.factor), as.character)) |>
  mutate(field_id = "sexy1",
         sea_name = "24/25",
         trt_name = trt_id,
         plot = as.numeric(plot))

d10 <-
  d9 |>
  select(-block) |>
  left_join(sexy1_plotkey |> select(plot, block))

#--make sure date is right, keep the columns I want
d11 <-
  d10 |>
  mutate(sampledate_ydm = ydm(sample_date),
         sampledate_ymd = paste(sampledate_year, sampledate_month, sampledate_day, sep = "-"),
         sampledate_ymd = ymd(sampledate_ymd)) |>
  select(field_id, sea_name, trt_name, block, plot,
         sampledate_id, #--some samplings were spread over two days, Emma is very precise
         sampledate_ymd,
         subsample_id,
         weedbiomass_kg_ha)

#--take the minimum date at every sampling point
d12 <-
  d11 |>
  group_by(sampledate_id) |>
  mutate(sampledate_ymd2 = min(sampledate_ymd))


d13 <-
  d12 |>
  mutate(biomass_cat = "weeds",
         data_type = "fallbio_kgha") |>
  rename(value = weedbiomass_kg_ha)

#--get last sampling to match with other biomass

d14 <-
  d13 |>
  ungroup() |>
  filter(sampledate_ymd2 == max(sampledate_ymd2))

d15 <-
  d14 |>
  arrange(block, plot) |>
  select(-sampledate_id, -sampledate_ymd, -subsample_id)



# 16. add weeds to other fallbio types ------------------------------------

#--clean up weeds data

d16 <-
  d8 |>
  bind_rows(d15) |>
  arrange(block, plot, sampledate_ymd2, data_type, biomass_cat)


# write it ----------------------------------------------------------------

sexy1_fallbio <-  d16

usethis::use_data(sexy1_fallbio, overwrite = TRUE)

sexy1_fallbio %>%
  write_csv("inst/extdata/sexy1_fallbio.csv")

