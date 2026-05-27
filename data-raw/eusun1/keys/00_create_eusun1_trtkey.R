#--last updated 27 may 2026

#--want something simple
# just trt_id: eusun1_24/25_p etc
#      trt_name: p
#      trt_desc: Perennial cereal rye...
#

#--free form description, but using commas with crop, planting season, relevant treatment descriptions


library(readxl)
library(tidyverse)

rm(list = ls())


# 1. raw data -------------------------------------------------------------

#--eusun1
d1 <-
  read_excel("data-raw/eusun1/keys/Eusun-treatments-from-Casandra.xlsx", skip = 2) |>
  select(trt_raw = Treatment) |>
  distinct()


# 2. trt names ------------------------------------------------------------

#--the treatment names are nonsense, make new ones

d2 <-
  d1 |>
  mutate(trt_desc = case_when(
    trt_raw == "17_West" ~ "Perennial cereal rye (P), planted fall 2024, 24 cm rows, 1/3 plant density (100 pl m-2), no biomass harvest", #---emailed casandra
    trt_raw == "18_West" ~ "Perennial cereal rye (P), planted fall 2024, 24 cm rows, 1/3 plant density (100 pl m-2), one May biomass harvest",
    trt_raw == "17_East" ~ "Perennial cereal rye (P), planted fall 2024, 24 cm rows, full plant density (300 pl m-2), no biomass harvest",
    trt_raw == "18_East" ~ "Perennial cereal rye (P), planted fall 2024, 24 cm rows, full plant density (300 pl m-2), one May biomass harvest")) |>
  mutate(trt_name = case_when(
    trt_raw == "17_West" ~ "p_lowdens", #---emailed casandra
    trt_raw == "18_West" ~ "p_lowdens_bioharv",
    trt_raw == "17_East" ~ "p_normdens",
    trt_raw == "18_East" ~ "p_normdens_bioharv")
  )


# 3. trt_id ---------------------------------------------------------------

#--make a trt_id for the first year
d3 <-
  d2 |>
  mutate(
    trt_id = paste("eusun1", "24/25", trt_name, sep = "_"))



# 4. rearrange ------------------------------------------------------------

d4 <-
  d3 |>
  select(trt_name, trt_id, trt_raw, trt_desc, trt_desc) |>
  arrange(trt_name)

# done --------------------------------------------------------------------

eusun1_trtkey <- d4

usethis::use_data(eusun1_trtkey, overwrite = TRUE)

eusun1_trtkey %>%
  write_csv("inst/extdata/eusun1_trtkey.csv")
