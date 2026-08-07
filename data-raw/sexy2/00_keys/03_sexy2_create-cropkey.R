# created: 7 aug 2026
# purpose: keep track of the seed source for each season

#---NEEDS UPDATED

library(readxl)
library(tidyverse)

rm(list = ls())

# 1. raw data -------------------------------------------------------------

d1 <-
  read_csv("inst/extdata/sexy2_trtkey.csv") |>
  select(field_id, sea_name, crop_name) |>
  distinct() |>
  separate_rows(crop_name, sep = ",") %>%  # split by comma
  mutate(crop_name = trimws(crop_name)) |>
  distinct() # remove extra spaces

# 2. provenance of seed -----------------------------------------------------------

d2 <-
  d1 %>%
  mutate(crop_desc = case_when(
    sea_name == "25/26" & crop_name == "p" ~ "Perennial cereal rye population from Germany, seed from Seed Increase 24/25 season",
    sea_name == "25/26" & crop_name == "a" ~ "Annual cereal rye (SU Thor) hybrid",

    sea_name == "26/27" & crop_name == "p" ~ "Perennial cereal rye population from Germany, seed from Seed Increase 25/26 season",
    sea_name == "26/27" & crop_name == "a" ~ "Annual cereal rye (XX) hybrid",

    TRUE ~ "XXXXX"
  ))


# 3. tkw-----------------------------------------------------------

d3 <-
  d2 %>%
  mutate(tkw_of_planted_seed_g = case_when(
    sea_name == "25/26" & crop_name == "p" ~ "need to look up", #--need to look up
    sea_name == "25/26" & crop_name == "a" ~ "need to look up",

    #--TBD
    sea_name == "26/27" & crop_name == "p" ~ "TBD",
    sea_name == "26/27" & crop_name == "a" ~ "TBD",

    TRUE ~ "XX"
  ))


# 4. germination -----------------------------------------------------------

d4 <-
  d3 %>%
  mutate(germination_pct = case_when(
    sea_name == "25/26" & crop_name == "p" ~ "need to look up", #--need to look up
    sea_name == "25/26" & crop_name == "a" ~ "need to look up",

    #--TBD
    sea_name == "26/27" & crop_name == "p" ~ "TBD",
    sea_name == "26/27" & crop_name == "a" ~ "TBD",

    TRUE ~ "XX"
  ))


# make data ---------------------------------------------------------------

sexy2_cropkey <-
  d4

usethis::use_data(sexy2_cropkey, overwrite = TRUE)

sexy2_cropkey %>%
  write_csv("inst/extdata/sexy2_cropkey.csv")


