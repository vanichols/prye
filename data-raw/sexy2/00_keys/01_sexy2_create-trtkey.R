# purpose:    have more info connected to trt_name
# created:    7 aug 2026
# notes:      based on sexy1 code

library(readxl)
library(tidyverse)

rm(list = ls())


# 1. raw data -------------------------------------------------------------

#--has same treatments as sexy1, handmade
#--pull out the unique treatments
#--sexy2x2 has same treatments as sexy1x1
d0 <-
  read_excel("data-raw/sexy1/00_keys/sexy1-2024_eukey.xlsx", skip = 5) |>
  select(trt_name = trt_id) |>
  filter(!is.na(trt_name)) |>
  distinct()

#--sexy2x2 - 25/26
d1a <-
  d0 |>
  mutate(
    field_id = "sexy2",
    sea_name = "25/26")

#--sexy2x3 - 26/27
#--has some additional treatments

d1b <-
  d0 |>
  add_row(trt_name = "p2") |>
  add_row(trt_name = "pcc2") |>
  mutate(
    field_id = "sexy2",
    sea_name = "26/27")


d1 <-
  d1a |>
  bind_rows(d1b)


# 2. add trt_desc -------------------------------------------------------

d2 <-
  d1 |>
  mutate(trt_desc = case_when(

    #--25/26 season
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

    #--26/27 season
    trt_name == "oats" ~ "Oats as reset crop, planted in spring, 12.5 cm rows, no post-harvest cover crop, herbicides",

    trt_name == "p2" ~ "Second year of perennial cereal rye (P), planted in fall, 12.5 cm rows, no post-harvest cover crop, herbicides",
    trt_name == "pcc2" ~ "Second year of perennial cereal rye (P), planted in fall, 12.5 cm rows, post-harvest cover crop mix, herbicides")
)


# 3. add crop_name ----------------------------------------------------------

#--multiple crops are separated by commas

d3 <-
  d2 |>
  mutate(
    crop_name = case_when(
      trt_name %in% c("p", "xp", "pcc", "xpcc", "p2", "pcc2") ~ "p",
      trt_name %in% c("a", "xa", "acc", "xacc") ~ "a",
      trt_name %in% c("aprows", "xaprows", "apmix", "xapmix") ~ "a, p",
      trt_name == "oats" ~ "oats"
    )
  )

# done --------------------------------------------------------------------

sexy2_trtkey <-
  d3 |>
  select(field_id, sea_name, trt_name, crop_name, everything()) |>
  arrange(sea_name, trt_name)

usethis::use_data(sexy2_trtkey, overwrite = TRUE)

sexy2_trtkey %>%
  write_csv("inst/extdata/sexy2_trtkey.csv")
