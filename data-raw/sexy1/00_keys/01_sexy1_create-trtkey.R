# purpose:    have more info connected to trt_name
# created:    july 2026
# notes:      includes sexy1 sea_name 24/25, 25/26 and 26/27

#--want something simple
# trt_id: sexy1_24/25_p etc
# trt_name: p
# trt_desc: Perennial cereal rye...
# crop_name: p, a (crop abbreviations separated by commas, these are described in sexy1_cropkey)
#
#--free form description, but using commas with crop, planting season, relevant treatment descriptions
#--note: treatments changed in 26/27

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

#--sexy1 - 24/25
d1a <-
  d0 |>
  mutate(
    field_id = "sexy1",
    sea_name = "24/25")

d1b <-
  tibble(trt_name = "oats",
         field_id = "sexy1",
         sea_name = "25/26")

#--sexy1 - 24/25 note! different treatments
d1c <-
  d0 |>
  filter(!trt_name %in% c("xapmix", "apmix", "aprows", "xaprows")) |>
  add_row(trt_name = "p1/2") |>
  add_row(trt_name = "pcc1/2") |>
  add_row(trt_name = "a1/2") |>
  add_row(trt_name = "acc1/2") |>
  mutate(
    field_id = "sexy1",
    sea_name = "26/27")

d1 <-
  d1a |>
  bind_rows(d1b) |>
  bind_rows(d1c)


# 2. add trt_desc -------------------------------------------------------

d2 <-
  d1 |>
  mutate(trt_desc = case_when(
    trt_name == "p" ~ "Perennial cereal rye (P), planted in fall, 12.5 cm rows, no post-harvest cover crop, herbicides",
    trt_name == "xp" ~ "Perennial cereal rye (P), planted in fall, 12.5 cm rows, no post-harvest cover crop, no herbicides",
    trt_name == "pcc" ~ "Perennial cereal rye (P), planted in fall, 12.5 cm rows, post-harvest cover crop mix, herbicides",
    trt_name == "xpcc" ~ "Perennial cereal rye (P), planted in fall, 12.5 cm rows, post-harvest cover crop mix, no herbicides",

    trt_name == "a" ~ "Annual cereal rye hybrid (A), planted in fall, 12.5 cm rows, no post-harvest cover crop, herbicides",
    trt_name == "xa" ~ "Annual cereal rye hybrid (A), planted in fall, 12.5 cm rows, no post-harvest cover crop, no herbicides",
    trt_name == "acc" ~ "Annual cereal rye hybrid (A), planted in fall, 12.5 cm rows, post-harvest cover crop mix, herbicides",
    trt_name == "xacc" ~ "Annual cereal rye hybrid (A), planted in fall, 12.5 cm rows, post-harvest cover crop mix, no herbicides",

    trt_name == "aprows" ~ "Annual cereal rye hybrid (A) and perennial cereal rye (P) mix, planted in fall, alternating 12.5 cm rows, no post-harvest cover crop, herbicides",
    trt_name == "xaprows" ~ "Annual cereal rye hybrid (A) and perennial cereal rye (P) mix, planted in fall, alternating 12.5 cm rows, no post-harvest cover crop, no herbicides",
    trt_name == "apmix" ~ "Annual cereal rye hybrid (A) and perennial cereal rye (P) mix, planted in fall, mixed 12.5 cm rows, no post-harvest cover crop, herbicides",
    trt_name == "xapmix" ~ "Annual cereal rye hybrid (A) and perennial cereal rye (P) mix, planted in fall, mixed 12.5 cm rows, no post-harvest cover crop, no herbicides",

    trt_name == "oats" ~ "Oats as reset crop, planted in spring, 12.5 cm rows, no post-harvest cover crop, herbicides",

    trt_name == "p1/2" ~ "Perennial cereal rye (P), planted in fall, 12.5 cm rows, no post-harvest cover crop, herbicides, half the full rate of nitrogen",
    trt_name == "pcc1/2" ~ "Perennial cereal rye (P), planted in fall, 12.5 cm rows, post-harvest cover crop mix, herbicides, half the full rate of nitrogen",
    trt_name == "a1/2" ~ "Annual cereal rye hybrid (A), planted in fall, 12.5 cm rows, no post-harvest cover crop, herbicides, half the full rate of nitrogen",
    trt_name == "acc1/2" ~ "Annual cereal rye hybrid (A), planted in fall, 12.5 cm rows, post-harvest cover crop mix, herbicides, half the full rate of nitrogen")
)


# 3. add crop_name ----------------------------------------------------------

#--multiple crops are separated by commas

d3 <-
  d2 |>
  mutate(
    crop_name = case_when(
      trt_name %in% c("p", "xp", "pcc", "xpcc", "p1/2", "pcc1/2") ~ "p",
      trt_name %in% c("a", "xa", "acc", "xacc", "a1/2", "acc1/2") ~ "a",
      trt_name %in% c("aprows", "xaprows", "apmix", "xapmix") ~ "a, p",
      trt_name == "oats" ~ "oats"
    )
  )

# done --------------------------------------------------------------------

sexy1_trtkey <-
  d3 |>
  select(field_id, sea_name, trt_name, crop_name, everything()) |>
  arrange(sea_name, trt_name)

usethis::use_data(sexy1_trtkey, overwrite = TRUE)

sexy1_trtkey %>%
  write_csv("inst/extdata/sexy1_trtkey.csv")
