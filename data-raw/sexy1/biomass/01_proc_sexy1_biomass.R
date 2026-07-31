# created           july 2026
# purpose:          get all grain yields in one place for sexy1
# last updated:

library(tidyverse)

rm(list = ls())

#--doesn't hold it's character for plot, ok...
sexy1_plotkey <-
  read_csv("inst/extdata/sexy1_plotkey.csv")

load("data-raw/sexy1/biomass/2025_emma_fallbiomass.rda")

#--field_id
#--sea_name
#--block
#--plot
#--trt_name

# 1. 2025 biomass, not broken down by category, needs a lot of wrangling ----------------------------------------------------------

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
         biomass_g = wholeplant_g,
         weed_pres) #--I'm not sure what weed_pres is...but they are all 'y'

#--take the minimum date at every sampling point
#STOPPED

d3 <-
  d2 |>
  select(field_id, sea_name, trt_name, block, plot,
         sampledate_id, #--some samplings were spread over two days, Emma is very precise
         sampledate_ymd = sample_date,
         subsample_id,
         samplearea_m2,
         biomass_g,
         weed_pres)


# write it ----------------------------------------------------------------

sexy1_grain <-  d2


usethis::use_data(sexy1_grain, overwrite = TRUE)

sexy1_grain %>%
  write_csv("inst/extdata/sexy1_grain.csv")

