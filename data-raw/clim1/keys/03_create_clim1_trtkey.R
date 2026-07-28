#--last updated 27 july 2027

#--want something simple
# just
#      field_id: clim1
#      trt_name: p
#      trt_desc: Perennial cereal rye; 12.5 cm rows; etc.... (separated by ;)
#

#--free form description, but using commas with crop, planting season, relevant treatment descriptions

library(readxl)
library(tidyverse)

rm(list = ls())


# 1. raw data -------------------------------------------------------------

#--clim1, handmade
d1 <-
  read_excel("data-raw/clim1/keys/treatment-key-v5.xlsx", skip = 5) |>
  select(field_id, trt_name, trt_nu, everything(), -sea_name) |>
  filter(!is.na(trt_name)) |>
  fill(field_id)


# 2. add trt_desc -------------------------------------------------------

d1 |>
  pull(trt_name) |>
  unique()

#############need to finish!!!

d2 <-
  d1 |>
  mutate(trt_desc = case_when(

    #//2026 spring planting
    trt_name == "26s_p" ~ "Perennial cereal rye (P); planted spring 2026; 12.5 cm rows; 80 kg of nitrogen at planting + 20 kg nitrogen after harvest; summer forage harvest",
    trt_name == "26s_pleg1" ~ "Perennial cereal rye (P) and Trifolium resupinatum (annual Persian clover cv. Pasat, leg1); planted spring 2026; 12.5 cm rows with leg1 in between; 80 kg of nitrogen at planting; summer forage harvest",
    trt_name == "26s_pleg2wide" ~ "Perennial cereal rye (P) and Medicago lupulina (perennial Black medic cv. Virgo pajbjerg, leg2); planted spring 2026; 25 cm rows with leg2 in between; 80 kg of nitrogen at planting; summer forage harvest",
    trt_name == "26s_pbuck" ~ "Perennial cereal rye (P) and buckwheat (cv Lileja); planted spring 2026; 12.5 cm rows with buck in between; 80 kg of nitrogen at planting; summer forage harvest",
    trt_name == "26s_pbuckwide" ~ "Perennial cereal rye (P) and buckwheat (cv Lileja); planted spring 2026; 25 cm rows with buck in between; 80 kg of nitrogen at planting; summer forage harvest",
    trt_name == "26s_w" ~ "Perennial wheat (W) from The Land Institute; planted spring 2026; 12.5 cm rows; 80 kg of nitrogen at planting; grain harvest in 2026",

    #//2026 fall palnting (still TBD)
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

    TRUE ~ "OOPS SOMETHING IS WRONG"
  ))


d2

# done --------------------------------------------------------------------

clim1_trtkey <-
  d2 |>
  select(field_id, trt_nu, trt_name, trt_desc, everything()) |>
  arrange(trt_nu)

usethis::use_data(clim1_trtkey, overwrite = TRUE)

clim1_trtkey %>%
  write_csv("inst/extdata/clim1_trtkey.csv")
