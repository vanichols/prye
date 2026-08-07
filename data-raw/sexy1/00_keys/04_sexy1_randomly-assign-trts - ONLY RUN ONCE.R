# created: 7 aug 2026
# purpose: randomly assign treatments to sexy1 field ONLY RUN THIS ONCE!!!!!!!

#--NOTE: you must run/create the sexy1_trtkey first

rm(list = ls())

library(tidyverse)
library(readxl)


# 1. 26/27 season--------------------------------------------------------

#--get treatments

t <-
  read_csv("inst/extdata/sexy1_trtkey.csv") |>
  filter(sea_name == "26/27")

#--should be 12
d1 <-
  t %>%
  select(trt_name) %>%
  distinct() %>%
  mutate(trt_nu = 1:n())

#--randomly assign each treatment to a plot within each block - only do this once
b1 <- sample(x = c(1:12), size = 12, replace = F)
b2 <- sample(x = c(1:12), size = 12, replace = F)
b3 <- sample(x = c(1:12), size = 12, replace = F)
b4 <- sample(x = c(1:12), size = 12, replace = F)

#--match the random number to its trt number
d2 <-
  tibble(b1 = b1,
         b2 = b2,
         b3 = b3,
         b4 = b4) %>%
  pivot_longer(b1:b4) %>%
  rename(trt_nu = value) %>%
  left_join(d1) %>%
  arrange(name)


#--write plot numbers
d3 <-
  d2 %>%
  group_by(name) %>%
  mutate(n = 1:n(),
         xx = as.numeric(str_sub(name, 2, 2)), #--make block numeric
         plot = xx * 100 + n)

d4 <-
  d3 %>%
  ungroup() |>
  mutate(field_id = "sexy1",
         sea_name = "26/27",
         block = str_to_upper(name)) |>
  select(field_id, sea_name, block, plot, trt_name)


d4 |>
  write_csv("data-raw/sexy1/01_keys/sexy1-2026-plot-assignments.csv")


d4 %>%
  ggplot(aes(as.factor(plot), as.factor(block))) +
  geom_tile(aes(fill = trt_name), color = "black") +
  geom_label(aes(label = trt_name), angle = 90) +
  facet_wrap(~block, scales = "free", ncol = 2)
