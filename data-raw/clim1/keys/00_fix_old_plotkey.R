#--last updated 28 jul 2026
#--old plot key has different trt_names

#--simple (see meta_plotkey for descriptions):
#     field_id: sexy1
#     block: B1
#     plot: 101
#     trt_name: apmix

library(readxl)
library(tidyverse)

rm(list = ls())

# 1. raw plot data with old trt names -------------------------------------------------------------

d1 <-  read_excel("data-raw/clim1/keys/plot-key-v1-old.xlsx")

# get the old treatment names connected to trt_nu, although they were wrong and I had to change them manually...

trt_old <-
  read_excel("data-raw/clim1/keys/treatment-key-v1.xlsx", skip = 5) |>
  select(trt_nu, trt_id) |>
  filter(!is.na(trt_nu)) |>
  filter(trt_nu < 10)

#--note: trt_id is old treatment name, its not what I want
# get the new ones

trt_new <-
  read_excel("data-raw/clim1/keys/treatment-key-v5.xlsx", skip = 5) |>
  select(trt_nu, trt_name) |>
  filter(trt_nu < 7) |>
  distinct()

trts_matched <-
  trt_new |>
  left_join(trt_old, by = "trt_nu")


# 2. make column names clean ----------------------------------------------
d2 <-
  d1 |>
  mutate(field_id = "clim1") |>
  select(field_id, block, plot, trt_id)


# 3. match new and old trt names ------------------------------------------

#--what are the d1 trt_ids? Are they the same as trt_old?

d2 |>
  select(trt_id) |>
  distinct() |>
  arrange(trt_id)

#--no, this has ROW instead of MIX
trts_matched

#--replace
trts_matched2 <-
  trts_matched |>
  mutate(trt_id = str_replace(trt_id, "ROW", "MIX"))

d3 <-
  d2 |>
  left_join(trts_matched2) |>
  select(-trt_id)

#--indicate where the practice plots are
d4 <-
  d3 |>
  mutate(trt_name = case_when(
    plot %in% c(101, 153, 201, 253, 301, 353, 401, 453) ~ "PRACTICE PLOT",
    TRUE ~ trt_name
  )) |>
  mutate(trt_nu = ifelse(trt_name == "PRACTICE PLOT", 0, trt_nu))

d4 |>
  write_xlsx("data-raw/clim1/keys/plot-key-v2.xlsx")

