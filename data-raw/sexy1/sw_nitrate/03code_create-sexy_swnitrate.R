#--created 28 july 2028
#--updated
#--purpose: read in lab's water nitrate data
#--NOTE: still missing 96 samples from March 2026, as of 3 Aug 2026

rm(list = ls())

library(dplyr)
library(readr)

# 0. data from cecilie -----------------------------------------------------------------

a0 <- read_csv("data-raw/sexy1/sw_nitrate/tidy_analyzerid-key.csv")

# 1. data from 01code_proc-raw... -----------------------------------------------------------------

a1a <-
  read_csv("data-raw/sexy1/sw_nitrate/tidy_raw-data.csv")

#--fix analyzerIDs (if needed)
a1a |>
  filter(analyzer_id == 45978)

a1b <-
  a1a |>
  mutate(analyzer_id = ifelse(analyzer_id == 45978, 20250240, analyzer_id))

a1b |>
  filter(analyzer_id == 20250240)

# 2. merge ----------------------------------------------------------------

a2 <-
  a0 |>
  left_join(
    a1b |>
      select(-lab_id, -filename)
  )

a2 |>
  filter(analyzer_id == 20250240)

# 3. add season_name -----------------------------------------------------------
a3 <-
  a2 |>
  mutate(sea_name = "24/25",
         plot = as.character(plot))


# 4. amount below detection --------------------------------------------

#--indicate where I make this assumption, but make them 0s so they are numeric
a4 <-
  a3 |>
  mutate(
    nitrate_sensored = case_when(
      grepl("under", nitraten_mgl) ~ T,
      TRUE ~ F),
    nitrate2 = case_when(
    grepl("under", nitraten_mgl) ~ 0,
    TRUE ~ as.numeric(nitraten_mgl)))

#--the Nas or ok, they should be NAs
#--mistet(flaske revnet)
#--ingen prove
#--also all the 2026 samples as of 3 Aug 2026
a4 |>
  filter(is.na(nitraten_mgl))

# 5. change to data_type and value notation -------------------------------

a5 <-
  a4 |>
  mutate(data_type = "nitrateN_mgl") |>
  rename(value = nitrate2) |>
  select(field_id, sea_name, sampledate_ymd = sample_date_ymd, plot, data_type, everything(), -nitraten_mgl)

# 6. failed plots ---------------------------------------------------------

#--plot 309 (annual) didn't have half the plot planted, all its readings should be NA
#--plots 203 and 212 didn't get the annual component planted, all readings should be NA
#--plot 206 had a cover crop planted on accident, all readings should be NA
a6 <-
  a5 |>
  mutate(value = case_when(
    plot %in% c("203", "212", "206", "309") ~ NA,
    TRUE ~ value
  ))



# 3. add a days since harvest column --------------------------------------

#--perennial harvested on 8/14, annual on 8/8
#--I need the trts to do that
#--for now assign it as the later date
a7 <-
  a6 |>
  mutate(harvest_ymd = as_date("2025-08-14"),
       days_after_harvest = sampledate_ymd - harvest_ymd,
       dah = as.numeric(days_after_harvest)) |>
  select(field_id, sea_name, sampledate_ymd, days_after_harvest, dah, everything())

# 3. write ----------------------------------------------------------------

sexy1_swnitrate <- a7

usethis::use_data(sexy1_swnitrate, overwrite = TRUE)
