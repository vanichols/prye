#--last updated 27 may 2026

#--want something simple
# just trt_id: sexy1_24/25_p etc
#      trt_name: p
#      trt_desc: Perennial cereal rye...
#

library(readxl)
library(tidyverse)

rm(list = ls())


# 1. raw data -------------------------------------------------------------

#--sexy1, handmade
#--pull out the unique treatments
d1 <-
  read_excel("data-raw/sexy1/keys/sexy1-2024_eukey.xlsx", skip = 5) |>
  select(trt_name = trt_id) |>
  filter(!is.na(trt_name)) |>
  distinct()

#--make a trt_id for the first year
d2 <-
  d1 |>
  mutate(
    trt_id = paste("sexy1", "24/25", trt_name, sep = "_"))

# 2. add trt_desc -------------------------------------------------------

d3 <-
  d2 |>
  mutate(trt_desc = case_when(
    trt_name == "p" ~ "Perennial cereal rye (P), planted fall 2024, 12.5 cm rows, no post-harvest cover crop, herbicides",
    trt_name == "xp" ~ "Perennial cereal rye (P), planted fall 2024, 12.5 cm rows, no post-harvest cover crop, no herbicides",
    trt_name == "pcc" ~ "Perennial cereal rye (P), planted fall 2024, 12.5 cm rows, post-harvset cover crop mix, herbicides",
    trt_name == "xpcc" ~ "Perennial cereal rye (P), planted fall 2024, 12.5 cm rows, post-harvset cover crop mix, no herbicides",

    trt_name == "a" ~ "Annual cereal rye hybrid (A), planted fall 2024, 12.5 cm rows, no post-harvest cover crop, herbicides",
    trt_name == "xa" ~ "Annual cereal rye hybrid (A), planted fall 2024, 12.5 cm rows, no post-harvest cover crop, no herbicides",
    trt_name == "acc" ~ "Annual cereal rye hybrid (A), planted fall 2024, 12.5 cm rows, post-harvest cover crop mix, herbicides",
    trt_name == "xacc" ~ "Annual cereal rye hybrid (A), planted fall 2024, 12.5 cm rows, post-harvest cover crop mix, no herbicides",

    trt_name == "aprows" ~ "Annual cereal rye hybrid (A) and perennial cereal rye (P) mix, planted fall 2024, alternating 12.5 cm rows, no post-harvest cover crop, herbicides",
    trt_name == "xaprows" ~ "Annual cereal rye hybrid (A) and perennial cereal rye (P) mix, planted fall 2024, alternating 12.5 cm rows, no post-harvest cover crop, no herbicides",
    trt_name == "apmix" ~ "Annual cereal rye hybrid (A) and perennial cereal rye (P) mix, planted fall 2024, mixed 12.5 cm rows, no post-harvest cover crop, herbicides",
    trt_name == "xapmix" ~ "Annual cereal rye hybrid (A) and perennial cereal rye (P) mix, planted fall 2024, mixed 12.5 cm rows, no post-harvest cover crop, no herbicides")
    )



# 4. Perennial ow widths -----------------------------------------------------------



# 5. planting and harvesting date --------------------------------------------------------

d5 <-
  d4 |>
  mutate(planting_date_ymd = ymd("2024-10-18"),
         grainharvest_date_ymd = case_when(
           trt_name %in% c("a", "acc", "xa", "xacc") ~ ymd("2025-08-08"), #--sexy1, annual
           trt_name %in% c("p", "pcc", "xp", "xpcc", "apmix", "xapmix", "aprows", "xaprows") ~ymd("2025-08-14")) #--perennial and mixes
           )

# done --------------------------------------------------------------------

sexy1_trtkey <-
  d3 |>
  arrange(trt_name)

usethis::use_data(sexy1_trtkey, overwrite = TRUE)

sexy1_trtkey %>%
  write_csv("inst/extdata/sexy1_trtkey.csv")
