# created           nov 2026
# purpose:          process raw grain yields from sexy2
# last updated:
# notes:            emma's sexy2 data doesn't include the protein or tkw, need to add it

library(tidyverse)
library(readxl)

rm(list = ls())

#--doesn't hold it's character for plot, ok...
sexy2_plotkey <-
  read_csv("inst/extdata/sexy2_plotkey.csv")

#--sexy1 grain yields for ref
sexy1_grain <-
  read_csv("inst/extdata/sexy1_grain.csv")

#--emmas processed data
load("data-raw/sexy2/grainyield/yield_sexy2.rda")

#--field_id
#--sea_name
#--block
#--plot
#--trt_name



# 1. process emma's data --------------------------------------------------

#--get columns I want
#--don't have protein or tkw...!!!!!!!!!!!!!!!!!
d1 <-
  yield_sexy2 |>
  select(field_id = trial_loc, sea_name = season, block, plot, trt_name = trt_id,
         grain_Mgha = grainyield_dry_ton_ha,
         straw_Mgha = strawyield_dry_ton_ha )


d2 <-
  d1 |>
  pivot_longer(grain_Mgha:straw_Mgha) |>
  rename(data_type = name)


# write it ----------------------------------------------------------------

sexy2_grain <-  d2

usethis::use_data(sexy2_grain, overwrite = TRUE)

sexy2_grain %>%
  write_csv("inst/extdata/sexy2_grain.csv")

