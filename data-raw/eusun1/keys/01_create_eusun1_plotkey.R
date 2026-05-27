#--last updated 27 may 2026

#--want something simple
# just plot_id: sexy1_101
#      sea_id: sexy1_24/25
#      plot: 101
#      block: B1
#      trt_name: p

library(tidyverse)
library(readxl)

rm(list = ls())

#--need trt_name created in 00_create_eusun_trtkey
d0 <- read_csv("inst/extdata/eusun1_trtkey.csv")



# ###############eusun1-24/25 ----------------------------------------------

#--the plots have different treatments
#--so a plot is not a unit that contains a uniform treatment
#--rename the plots

e1 <-
  read_excel("data-raw/eusun1/keys/Eusun-treatments-from-Casandra.xlsx", sheet = "Grain", skip = 2) |>
  janitor::clean_names() |>
  select(plotraw = plot, treatment) |>
  #--make the plot unique for each treatment
  separate(treatment, into = c("xx", "plotinfo"), remove = F)

#--assign the plots to blocks
e2 <-
  e1 |>
  mutate(block = case_when(
    plotraw %in% c(8, 55) ~ "B4", #--block 4
    plotraw %in% c(13, 69) ~ "B3", #--block 3
    plotraw %in% c(4, 3) ~ "B2", #--block 2
    plotraw %in% c(26, 66) ~ "B1", #--block 1
    TRUE ~ "999999"
  ))

#--make the plot ids unique for a treatment
e3 <-
  e2 |>
  mutate(
    plotinfo = str_sub(plotinfo, 1, 1),
    plot = paste0(plotraw, plotinfo)
  ) |>
  select(block, plot, trt_raw = treatment)


#--the trt_id is nonsense
# use the ones I created
e4 <-
  e3 |>
  left_join(d0 |> select(trt_name, trt_raw) |> distinct()) |>
  select(-trt_raw)



# put into format ---------------------------------------------------------

e5 <-
  e4 |>
  mutate(plot_id = paste("eusun1", plot, sep = "_"),
         sea_id = "eusun1_24/25") |>
  select(plot_id, sea_id, plot, block, trt_name) |>
  arrange(block)

eusun1_plotkey <- e5

usethis::use_data(eusun1_plotkey, overwrite = TRUE)

eusun1_plotkey %>%
  write_csv("inst/extdata/eusun1_plotkey.csv")

