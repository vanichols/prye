# created           july 2026
# purpose:          get all grain yields in one place for sexy1
# last updated:

library(tidyverse)

rm(list = ls())

#--doesn't hold it's character for plot, ok...
sexy1_plotkey <-
  read_csv("inst/extdata/sexy1_plotkey.csv")

load("data-raw/sexy1/grain/op_yields.rda")

#--field_id
#--sea_name
#--block
#--plot
#--trt_name

# 1. 2025 yields ----------------------------------------------------------

#--get columns I want
d1 <-
  op_yields |>
  mutate(field_id = "sexy1",
         sea_name = "24/25",
         trt_name = trt_id,
         plot = as.numeric(plot_id)) |>
  left_join(sexy1_plotkey)

d2 <-
  d1 |>
  select(field_id, sea_name, trt_name, block, plot, data_type = name, value)


# write it ----------------------------------------------------------------

sexy1_grain <-  d2

usethis::use_data(sexy1_grain, overwrite = TRUE)

sexy1_grain %>%
  write_csv("inst/extdata/sexy1_grain.csv")

