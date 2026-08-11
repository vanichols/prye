# created           aug 2026
# purpose:          get easy access to general mgmt things
# last updated:

library(tidyverse)
library(readxl)

rm(list = ls())



# 1. 24/25 season ---------------------------------------------------------

d <- read_excel("data-raw/sexy1/mgmt/sexy1_mgmt-created-manually-from-fieldlog.xlsx",
           sheet = "sexy1x1",
           skip = 5)

d1 <-
  d |>
  fill(loc_name, sea_name) |>
  janitor::clean_names() |>
  mutate(date_ymd = ymd(date_dmy)) |>
  select(-date_dmy)

# write it ----------------------------------------------------------------

sexy1_mgmt <-  d1

usethis::use_data(sexy1_mgmt, overwrite = TRUE)

sexy1_mgmt %>%
  write_csv("inst/extdata/sexy1_mgmt.csv")

