# created : 27 july 2027
# purose: hold treatment info, same format as sexy1

#--want something simple
# just
#      field_id: clim1
#      trt_name: p
#      trt_desc: Perennial cereal rye; 12.5 cm rows; etc.... (separated by ;)
#      crop_name: a, p, etc. separated by ;

#--free form description, but using commas with crop, planting season, relevant treatment descriptions

#--NOTE: add crop details in cropkey code!

library(readxl)
library(tidyverse)

rm(list = ls())

#--handmade, update it every time a treatment number is assigned a treatment name
d0 <- read_excel("data-raw/clim1/00_keys/running-treatment-key.xlsx", skip = 5)



# 0. empty treatments -----------------------------------------------------

d_empty <-
  d0 |>
  filter(is.na(sea_name)) |>
  mutate(trt_desc = NA,
         crop_name = NA) |>
  select(field_id, sea_name, trt_name, trt_nu, trt_desc, crop_name)


# 26/27 -------------------------------------------------------------


# A. 26/27 -----------------------------------------------------------------

#--treatments are year-of-planting-specific

#--keep only 26/27 treatments here
a1 <-
  d0 |>
  filter(sea_name == "26/27") |>
  fill(field_id)


# 2. add trt_desc to sea_name 26/27-------------------------------------------------------

a1 |>
  pull(trt_name) |>
  unique()

#--not finalized--------updated 7 aug 2026 - we might get some more perennial wheat

a2a <-
  a1 |>
  mutate(trt_desc = case_when(

    #//2026 spring planting
    trt_name == "26s_p" ~ "Perennial cereal rye (P); planted spring 2026; 12.5 cm rows; 80 kg of nitrogen at planting + 20 kg nitrogen after harvest; summer forage harvest",
    trt_name == "26s_pleg1" ~ "Perennial cereal rye (P) and Trifolium resupinatum (annual Persian clover cv. Pasat, leg1); planted spring 2026; 12.5 cm rows with leg1 in between; 80 kg of nitrogen at planting; summer forage harvest",
    trt_name == "26s_pleg2wide" ~ "Perennial cereal rye (P) and Medicago lupulina (perennial Black medic cv. Virgo pajbjerg, leg2); planted spring 2026; 25 cm rows with leg2 in between; 80 kg of nitrogen at planting; summer forage harvest",
    trt_name == "26s_pbuck" ~ "Perennial cereal rye (P) and buckwheat (cv Lileja); planted spring 2026; 12.5 cm rows with buck in between; 80 kg of nitrogen at planting; summer forage harvest",
    trt_name == "26s_pbuckwide" ~ "Perennial cereal rye (P) and buckwheat (cv Lileja); planted spring 2026; 25 cm rows with buck in between; 80 kg of nitrogen at planting; summer forage harvest",
    trt_name == "26s_w" ~ "Perennial wheat (W) from The Land Institute; planted spring 2026; 12.5 cm rows; 80 kg of nitrogen at planting; grain harvest in 2026",

    #//2026 fall planting (still TBD)
    trt_name == "26f_p" ~ "Perennial cereal rye (P); planted fall 2026; 12.5 cm rows; ?? nitrogen",
    trt_name == "26f_p0" ~ "Perennial cereal rye (P); planted fall 2026; 12.5 cm rows; no nitrogen",
    trt_name == "26f_pwide" ~ "Perennial cereal rye (P); planted fall 2026; 25 cm rows; ?? nitrogen",
    trt_name == "26f_p0wide" ~ "Perennial cereal rye (P); planted fall 2026; 25 cm rows; no nitrogen",

    trt_name == "26f_apmix" ~ "Perennial cereal rye (P) and Dukato population rye (A) mixed together before planting; planted fall 2026; 12.5 cm rows; ?? nitrogen",
    trt_name == "26f_apmixwide" ~ "Perennial cereal rye (P) and Dukato population rye (A) mixed together before planting; planted fall 2026; 25 cm rows; ?? nitrogen",
    trt_name == "26f_aprowwide" ~ "Perennial cereal rye (P) and Dukato population rye (A) in alternating rows; planted fall 2026; 25 cm rows with A in between; ?? nitrogen",

    trt_name == "26f_a" ~ "Dukato population rye (A); planted fall 2026; 12.5 cm rows; ?? nitrogen",
    trt_name == "26f_awide" ~ "Dukato population rye (A); planted fall 2026; 25 cm rows; ?? nitrogen",

    trt_name == "26f_borris" ~ "Borris a popular; planted fall 2026; 12.5 cm rows; no nitrogen",
    trt_name == "26f_reimontra" ~ "Dukato population rye (A); planted fall 2026; 25 cm rows; ?? nitrogen",

    #--this one is tentative
    trt_name == "26f_p0leg2" ~ "Perennial cereal rye (P) and Medicago lupulina (perennial Black medic cv. Virgo pajbjerg, leg2); planted fall 2026; 25 cm rows with leg2 in between; no nitrogen",

    TRUE ~ "OOPS SOMETHING IS WRONG"
  ))


#--check it
a2a

a2b <-
  a2a |>
  select(field_id, sea_name, trt_name, trt_nu, trt_desc)

a2 <- a2b


# 3. add crop_name --------------------------------------------------------

a3 <-
  a2 |>
  mutate(crop_name = case_when(

    #//2026 spring planting
    trt_name == "26s_p" ~ "p",
    trt_name == "26s_pleg1" ~ "p; leg1",
    trt_name == "26s_pleg2wide" ~ "p; leg2",
    trt_name == "26s_pbuck" ~ "p; buck",
    trt_name == "26s_pbuckwide" ~ "p; buck",
    trt_name == "26s_w" ~ "w",

    #//2026 fall planting (still TBD)
    trt_name == "26f_p" ~ "p",
    trt_name == "26f_p0" ~ "p",
    trt_name == "26f_pwide" ~ "p",
    trt_name == "26f_p0wide" ~ "p",

    trt_name == "26f_apmix" ~ "a; p",
    trt_name == "26f_apmixwide" ~ "a; p",
    trt_name == "26f_aprowwide" ~ "a; p",

    trt_name == "26f_a" ~ "a",
    trt_name == "26f_awide" ~ "a",

    trt_name == "26f_borris" ~ "borris",
    trt_name == "26f_reimontra" ~ "reimontra",
    trt_name == "26f_p0leg2" ~ "p; leg2",

    TRUE ~ "OOPS SOMETHING IS WRONG"
  ))


# C. combine -----------------------------------------------------------------

c <-
  a3 |>
  bind_rows(d_empty) |>
  arrange(trt_nu)



# done --------------------------------------------------------------------

clim1_trtkey <-
  c |>
  select(field_id, sea_name, trt_nu, trt_name, crop_name, trt_desc, everything()) |>
  arrange(trt_nu)

usethis::use_data(clim1_trtkey, overwrite = TRUE)

clim1_trtkey %>%
  write_csv("inst/extdata/clim1_trtkey.csv")
