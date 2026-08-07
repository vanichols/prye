# created: 7 aug 2026
# purpose: keep track of the seed source for each season

#---NEEDS UPDATED FOR 26/27 season!!!!

library(readxl)
library(tidyverse)

rm(list = ls())

# 1. raw data -------------------------------------------------------------

d1 <-
  read_csv("inst/extdata/sexy1_trtkey.csv") |>
  select(field_id, sea_name, crop_name) |>
  distinct() |>
  separate_rows(crop_name, sep = ",") %>%  # split by comma
  mutate(crop_name = trimws(crop_name))        # remove extra spaces

# 2. provenance of seed -----------------------------------------------------------

d2 <-
  d1 %>%
  mutate(crop_desc = case_when(
    sea_name == "24/25" & crop_name == "p" ~ "Perennial cereal rye population from Germany, seed from Foulum 23/24 season (which had 2% ergot when received)",
    sea_name == "24/25" & crop_name == "a" ~ "Annual cereal rye (SU Thor) hybrid",

    sea_name == "26/27" & crop_name == "p" ~ "Perennial cereal rye population from Germany, seed from Seed Increase 25/26 season",
    sea_name == "26/27" & crop_name == "a" ~ "Annual cereal rye (XXXXX) hybrid",

    TRUE ~ "XXXXX"
  ))


# 3. tkw-----------------------------------------------------------

d3 <-
  d2 %>%
  mutate(tkw_of_planted_seed_g = case_when(
    sea_name == "24/25" & crop_name == "p" ~ "27",
    sea_name == "24/25" & crop_name == "a" ~ "42",

    #--TBD
    sea_name == "26/27" & crop_name == "p" ~ "XX",
    sea_name == "26/27" & crop_name == "a" ~ "XX",

    TRUE ~ "XX"
  ))


# 4. germination -----------------------------------------------------------

d4 <-
  d3 %>%
  mutate(germination_pct = case_when(
    sea_name == "24/25" & crop_name == "p" ~ "86",
    sea_name == "24/25" & crop_name == "a" ~ "95",

    sea_name == "26/27" & crop_name == "p" ~ "XX",
    sea_name == "26/27" & crop_name == "a" ~ "XX",

    TRUE ~ "XX"
  ))


# make data ---------------------------------------------------------------

sexy1_cropkey <-
  d4

usethis::use_data(sexy1_cropkey, overwrite = TRUE)

sexy1_cropkey %>%
  write_csv("inst/extdata/sexy1_cropkey.csv")


