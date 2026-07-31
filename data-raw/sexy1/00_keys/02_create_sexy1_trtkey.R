# purpose:    have more info connected to trt_name
# created:    july 2026

#--want something simple
# trt_id: sexy1_24/25_p etc
# trt_name: p
# trt_nice: Perennial rye
# trt_niceshort: A/P mix, (P)+, (Pcc)+ etc. ??
# trt_desc: Perennial cereal rye...
#

#--free form description, but using commas with crop, planting season, relevant treatment descriptions

library(readxl)
library(tidyverse)

rm(list = ls())


# 1. raw data -------------------------------------------------------------

#--sexy1, handmade
#--pull out the unique treatments
d0 <-
  read_excel("data-raw/sexy1/00_keys/sexy1-2024_eukey.xlsx", skip = 5) |>
  select(trt_name = trt_id) |>
  filter(!is.na(trt_name)) |>
  distinct()

#--make a trt_id for the first year
d1 <-
  d0 |>
  mutate(
    field_id = "sexy1",
    sea_name = "24/25",
    trt_id = paste(field_id, sea_name, trt_name, sep = "_"))

# 2. add trt_desc -------------------------------------------------------

d2 <-
  d1 |>
  mutate(trt_desc = case_when(
    trt_name == "p" ~ "Perennial cereal rye (P), planted fall 2024, 12.5 cm rows, no post-harvest cover crop, herbicides",
    trt_name == "xp" ~ "Perennial cereal rye (P), planted fall 2024, 12.5 cm rows, no post-harvest cover crop, no herbicides",
    trt_name == "pcc" ~ "Perennial cereal rye (P), planted fall 2024, 12.5 cm rows, post-harvest cover crop mix, herbicides",
    trt_name == "xpcc" ~ "Perennial cereal rye (P), planted fall 2024, 12.5 cm rows, post-harvest cover crop mix, no herbicides",

    trt_name == "a" ~ "Annual cereal rye hybrid (A), planted fall 2024, 12.5 cm rows, no post-harvest cover crop, herbicides",
    trt_name == "xa" ~ "Annual cereal rye hybrid (A), planted fall 2024, 12.5 cm rows, no post-harvest cover crop, no herbicides",
    trt_name == "acc" ~ "Annual cereal rye hybrid (A), planted fall 2024, 12.5 cm rows, post-harvest cover crop mix, herbicides",
    trt_name == "xacc" ~ "Annual cereal rye hybrid (A), planted fall 2024, 12.5 cm rows, post-harvest cover crop mix, no herbicides",

    trt_name == "aprows" ~ "Annual cereal rye hybrid (A) and perennial cereal rye (P) mix, planted fall 2024, alternating 12.5 cm rows, no post-harvest cover crop, herbicides",
    trt_name == "xaprows" ~ "Annual cereal rye hybrid (A) and perennial cereal rye (P) mix, planted fall 2024, alternating 12.5 cm rows, no post-harvest cover crop, no herbicides",
    trt_name == "apmix" ~ "Annual cereal rye hybrid (A) and perennial cereal rye (P) mix, planted fall 2024, mixed 12.5 cm rows, no post-harvest cover crop, herbicides",
    trt_name == "xapmix" ~ "Annual cereal rye hybrid (A) and perennial cereal rye (P) mix, planted fall 2024, mixed 12.5 cm rows, no post-harvest cover crop, no herbicides")
    )


# 3. add a trt_nice for fig labels ----------------------------------------

d3 <-
  d2 |>
  mutate(trt_nice = case_when(
  trt_name %in% c("a", "acc", "xa", "xacc") ~ "Annual",
  trt_name %in% c("p", "pcc", "xp", "xpcc") ~ "Perennial",
  trt_name %in% c("apmix", "xapmix") ~ "Annual/Perennial Mix",
  trt_name %in% c("aprows", "xaprows") ~ "Annual/Perennial Mix",
))

# done --------------------------------------------------------------------

sexy1_trtkey <-
  d3 |>
  select(field_id, sea_name, everything()) |>
  arrange(trt_name)

usethis::use_data(sexy1_trtkey, overwrite = TRUE)

sexy1_trtkey %>%
  write_csv("inst/extdata/sexy1_trtkey.csv")
