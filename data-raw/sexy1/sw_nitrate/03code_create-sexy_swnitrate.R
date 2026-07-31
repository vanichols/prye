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
  mutate(sea_name = "24/25",
         plot = as.character(plot)) |>
  select(-analyzer_id)


# 4. amount below detection, 0 --------------------------------------------

a4 <-
  a3 |>
  mutate(nitrate2 = case_when(
    grepl("under", nitraten_mgl) ~ 0,
    TRUE ~ as.numeric(nitraten_mgl)))

#--the Nas or ok
a4 |>
  filter(is.na(nitraten_mgl))

# 5. change to data_type and value notation -------------------------------

a5 <-
  a4 |>
  mutate(data_type = "nitrateN_mgl") |>
  rename(value = nitrate2) |>
  select(field_id, sea_name, sampledate_ymd = sample_date_ymd, plot, data_type, everything(), -nitraten_mgl)

# 6. failed plots ---------------------------------------------------------

#--plots 203 and 212 were failed mixed plantings, remove them
a6 <-
  a5 |>
  mutate(value = case_when(
    plot %in% c("203", "212") ~ NA,
    TRUE ~ value
  ))

# 3. write ----------------------------------------------------------------

sexy1_swnitrate <- a6

usethis::use_data(sexy1_swnitrate, overwrite = TRUE)
