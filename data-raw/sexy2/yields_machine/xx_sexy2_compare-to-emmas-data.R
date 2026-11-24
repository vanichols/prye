# created           nov 2026
# purpose:          process machine grain and straw yields from sexy2
# last updated:
# notes:            using the file from emma's package

library(tidyverse)
library(readxl)
library(lubridate)

rm(list = ls())

#--doesn't hold it's character for plot, ok...
sexy2_plotkey <-
  read_csv("inst/extdata/sexy2_plotkey.csv") |>
  filter(sea_name == "25/26")

load("data-raw/sexy2/yields_machine/yield_sexy2.rda")

#--field_id
#--sea_name
#--trt_name
#--block
#--plot
#--data_type (machine_drygrain_Mgha, machine_drystraw_Mgha, tkw_g, protein_pct)
#--value

#--whether it is 2.4 or 2.5 is a bit of a philosophical debate...what did emma use?
plot_size_ha <- 2.4 * 10 / 10000


# raw files ---------------------------------------------------------------
