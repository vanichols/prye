# created: 7 aug 2026
# purpose: keep track of the seed source for each season

#---NEEDS UPDATED FOR 26/27 season!!!!

library(readxl)
library(tidyverse)

rm(list = ls())

# example from sexy1 ------------------------------------------------------


# 1. raw data -------------------------------------------------------------

d1 <-
  read_csv("inst/extdata/clim1_trtkey.csv") |>
  select(field_id, sea_name, crop_name) |>
  distinct() |>
  separate_rows(crop_name, sep = ";") %>%  # split by semicolon
  mutate(crop_name = trimws(crop_name))        # remove extra spaces

# 2. provenance of seed -----------------------------------------------------------

d1 |>
  select(crop_name) |>
  distinct()

d2 <-
  d1 %>%
  mutate(crop_desc = case_when(
    sea_name == "26/27" & crop_name == "p" ~ "Perennial cereal rye population from Germany, seed from Seed Increase 25/26",

    sea_name == "26/27" & crop_name == "leg1" ~ "Trifolium resupinatum (annual Persian clover cv. Pasat) ordered from XX",
    sea_name == "26/27" & crop_name == "leg2" ~ "Medicago lupulina (perennial Black medic cv. Virgo pajbjerg) ordered from XX",

    sea_name == "26/27" & crop_name == "buck" ~ "Fagopyrum esculentum (buckwheat cv. Lileja)",

    sea_name == "26/27" & crop_name == "w" ~ "Perennial wheat (Triticum spp. x Thinopyrum spp.) from The Land Institute B1107E produced 2025",

    sea_name == "26/27" & crop_name == "a" ~ "Dukato population rye ordered from DLG (organic seed)",

    sea_name == "26/27" & crop_name == "borris" ~ "A landrace rye offered by Landsorten - Claus emailed Bjarne about getting seed",
    sea_name == "26/27" & crop_name == "reimontra" ~ "Claus obtained seed from “Revierberatung Wolmersdorf”
https://www.saatgut-shop.de/product_info.php?info=p208_roggen---waldstaudenroggen-reimonta---secale-multicaule----1-kg.html
 in 2026, likely a tetraploid but we are unsure",

    TRUE ~ "XXXXX"
  ))


# 3. tkw-----------------------------------------------------------

#--thse are the only important ones
d3 <-
  d2 %>%
  mutate(tkw_of_planted_seed_g = case_when(
    #--TBD
    sea_name == "26/27" & crop_name == "p" ~ "XX",
    sea_name == "26/27" & crop_name == "a" ~ "XX",

    TRUE ~ "unknkown"
  ))


# 4. germination -----------------------------------------------------------

d4 <-
  d3 %>%
  mutate(germination_pct = case_when(
    #--TBD
    sea_name == "26/27" & crop_name == "p" ~ "XX",
    sea_name == "26/27" & crop_name == "a" ~ "XX",

    TRUE ~ "unknkown"
  ))


# make data ---------------------------------------------------------------

clim1_cropkey <- d4

usethis::use_data(clim1_cropkey, overwrite = TRUE)

clim1_cropkey %>%
  write_csv("inst/extdata/clim1_cropkey.csv")


