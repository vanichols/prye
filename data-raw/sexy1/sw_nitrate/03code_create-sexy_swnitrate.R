#--created 28 july 2028
#--updated
#--purpose: read in lab's water nitrate data

rm(list = ls())

library(dplyr)
library(readr)

# 1. datreadr_example()# 1. data -----------------------------------------------------------------

a1a <- read_csv("data-raw/sexy1/sw_nitrate/tidy_analyzerid-key.csv")
a1b <- read_csv("data-raw/sexy1/sw_nitrate/tidy_raw-data.csv")


# 2. merge ----------------------------------------------------------------

a2 <-
  a1a |>
  left_join(
    a1b |>
      select(-lab_id, -filename)
  )


# 3. add season_name -----------------------------------------------------------
a3 <-
  a2 |>
  mutate(sea_name = "25/26") |>
  select(field_id, sea_name, everything())

# 3. write ----------------------------------------------------------------

sexy1_swnitrate <- a3

usethis::use_data(sexy1_swnitrate, overwrite = TRUE)
