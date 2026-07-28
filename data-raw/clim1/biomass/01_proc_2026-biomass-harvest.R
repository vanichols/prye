# created 28 july 2026
# purpose: process the cadillac biomass harvest and separation anders and cecilie did


library(tidyverse)
library(readxl)

rm(list = ls())

raw <- read_excel("data-raw/clim1/biomass/2026-07-21_Climax Forage harvest-manual.xlsx", sheet = "hand", skip = 5)

clim1_plotkey <- read_csv("inst/extdata/clim1_plotkey.csv")


# 1. clean names ----------------------------------------------------------

d1 <-
  raw |>
  janitor::clean_names()


# 2. look at treatments make sure they match ------------------------------

trts <- clim1_plotkey |> select(plot, trt_name)

trts |>
  filter(plot == 314)

d1 |>
  filter(plot == 314)

#--they match, great
d1 |>
  select(plot, old_name = name, trt_name) |>
  left_join(trts, by = c("plot", "trt_name"))

d2 <-
  d1 |>
  select(-name)


# 3. long form ----------------------------------------------------------------

d3 <-
  d2 |>
  left_join(clim1_plotkey) |>
  select(field_id, block, plot, trt_name, perennial_rye, companion_crop, weeds) |>
  pivot_longer(perennial_rye:weeds) |>
  mutate(data_type = "forage_g_m2",
         sampledate_ymd = "2026-07-21") |>
  rename(biomass_cat = name)


# 4. NAs are zeros in this case -------------------------------------------

d4 <-
  d3 |>
  mutate(value = ifelse(is.na(value), 0, value),
         sampledate_ymd = ymd(sampledate_ymd))


# 5. write it -------------------------------------------------------------

clim1_forage <-
  d4 |>
  select(field_id, block, plot, trt_name, data_type, sampledate_ymd, biomass_cat, value)


usethis::use_data(clim1_forage, overwrite = TRUE)

clim1_forage %>%
  write_csv("inst/extdata/clim1_forage.csv")


