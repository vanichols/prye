#--manually create a list of the seed sources for each field

library(readxl)
library(tidyverse)

rm(list = ls())


d <- tribble(
  ~field_id,      ~sea_id,          ~crop_name,                      ~crop_provenance,
  "sexy1",        "sexy1_24/25",      "perennial rye",         "Perennial cereal rye population from Germany, seed from Foulum 23/24 season (which had 2% ergot when received)",
  "sexy1",        "sexy1_24/25",       "annual rye",           "Annual cereal rye (SU Thor) hybrid",

  "sexy2",        "sexy2_24/25",      "perennial rye",         "Perennial cereal rye population from RePhilDK25 (seed increase harvested in Flakkebjerg from seed1 field in 2025)",
  "sexy2",        "sexy2_24/25",       "annual rye",           "Annual cereal rye (??) hybrid",

  "seed1",        "sexy1_24/25",      "perennial rye",         "Perennial cereal rye population from Germany, seed from Foulum 23/24 season (which had 2% ergot when received)",
  "seed1",        "sexy1_25/26",       "perennial rye",           "Perennial cereal rye population from RePhilDK25 (seed increase harvested in Flakkebjerg from seed1 field in 2025)",

  "eusun1",       "eusun1_24/25",      "perennial rye",         "Perennial cereal rye population from Germany, seed from Foulum 23/24 season (which had 2% ergot when received)",

  "clim1",        "clim1_26/27",      "spring perennial rye",         "Perennial cereal rye population from RePhilDK25 (seed increase harvested in Flakkebjerg from seed1 field in 2025)"

  )


# 1. tkw-----------------------------------------------------------

d1 <-
  d %>%
  mutate(tkw_of_planted_seed_g = case_when(
    sea_id == "sexy1_24/25" & crop_name == "perennial rye" ~ "27",
    sea_id == "sexy1_24/25" & crop_name == "perennial rye" ~ "27",

    sea_id == "seed1_24/25" & crop_name == "perennial rye" ~ "27",
    sea_id == "seed1_25/26" & crop_name == "perennial rye" ~ "23.5", #--seed inc source

    sea_id == "sexy1_24/25" & crop_name == "annual rye" ~ "42",

    sea_id == "sexy2_25/26" & crop_name == "perennial rye" ~ "23.5",#--seed inc source
    sea_id == "sexy2_25/26" & crop_name == "annual rye" ~ "41.5",
    TRUE ~ "Either NA or unknown"
  ))


# 2. germination -----------------------------------------------------------

d2 <-
  d1 %>%
  mutate(germination_pct = case_when(
    crop_provenance == "Perennial cereal rye population from Germany, seed from Foulum 23/24 season (which had 2% ergot when received)"
    ~ "86",
    crop_provenance == "Annual cereal rye (SU Thor) hybrid"
    ~ "95",
    crop_provenance == "Perennial cereal rye population from RePhilDK25 (seed increase harvested in Flakkebjerg from seed1 field in 2025)"
    ~ "65",
    crop_provenance == "Annual cereal rye (??) hybrid"
    ~ "85",
    TRUE ~ "NA or unknown"
  ))


# make data ---------------------------------------------------------------

prye_seedsourcekey <- d2

usethis::use_data(prye_seedsourcekey, overwrite = TRUE)

prye_seedsourcekey %>%
  write_csv("inst/extdata/prye_seedsourcekey.csv")


