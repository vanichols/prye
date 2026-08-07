# created: 8 aug 2026
# purpose: assign treatments to plots for each season

#--NOTE changed (27 jul) to:
# field_id: sexy1
# sea_name: 24/25
# block: B1
# plot: 101 (but as a character!)
# trt_name; apmix


library(readxl)
library(tidyverse)

rm(list = ls())


# 1. sexy2 25/26 -------------------------------------------------------------

#--handmade
d1a <-
  read_excel("data-raw/sexy2/00_keys/sexy2-2025_eukey.xlsx", skip = 5) |>
  select(
    block,
    plot,
    trt_name = trt) |>
  filter(!is.na(trt_name)) |>
  distinct()

#--sexy2, 25/26, block as B1
d1b <-
  d1a |>
  mutate(
    field_id = "sexy2",
    sea_name = "25/26",
    block = str_to_upper(block),
    plot = as.character(plot))

d1c <-
  d1b |>
  select(field_id, sea_name, block, plot, trt_name)

#--final
d1 <- d1c

# 2. sexy1 26/27 -------------------------------------------------------------

#--start with d1
d2a <-
  d1 |>
  rename(trt_name_old = trt_name,
         sea_name_old = sea_name)

mixed_plots <- c("apmix", "aprows", "xapmix", "xaprows")

d2b <-
  d2a |>
  mutate(sea_name = "26/27",
         trt_name = case_when(

           #--6 treatments getting oats
           trt_name_old %in% c("a", "acc", "xacc", "xa", "xp", "xpcc") ~ "oats",

           #--p and pcc staying
           trt_name_old %in% c("p") ~ "p2",
           trt_name_old %in% c("pcc") ~ "pcc2",

           #--the mixes depend on the block
           trt_name_old == mixed_plots[1] & block == "B1" ~ "acc",
           trt_name_old == mixed_plots[2] & block == "B2" ~ "acc",
           trt_name_old == mixed_plots[3] & block == "B3" ~ "acc",
           trt_name_old == mixed_plots[4] & block == "B4" ~ "acc",

           trt_name_old == mixed_plots[2] & block == "B1" ~ "a",
           trt_name_old == mixed_plots[3] & block == "B2" ~ "a",
           trt_name_old == mixed_plots[4] & block == "B3" ~ "a",
           trt_name_old == mixed_plots[1] & block == "B4" ~ "a",


           trt_name_old == mixed_plots[3] & block == "B1" ~ "pcc",
           trt_name_old == mixed_plots[4] & block == "B2" ~ "pcc",
           trt_name_old == mixed_plots[1] & block == "B3" ~ "pcc",
           trt_name_old == mixed_plots[2] & block == "B4" ~ "pcc",


           trt_name_old == mixed_plots[4] & block == "B1" ~ "p",
           trt_name_old == mixed_plots[1] & block == "B2" ~ "p",
           trt_name_old == mixed_plots[2] & block == "B3" ~ "p",
           trt_name_old == mixed_plots[3] & block == "B4" ~ "p",

           TRUE ~ "UHOH"

         )
  )


d2b |>
  mutate(h = 1) |>
  ggplot(aes(plot, h)) +
  geom_col(aes(fill = trt_name)) +
  geom_label(aes(y = 0.5, label = trt_name_old), angle = 90) +
  facet_wrap(~block, scales = "free") +
  scale_fill_manual(values = c("gray", "lightblue", "white", "green3", "pink", "yellow", "purple"))


d2 <- d2b

# done --------------------------------------------------------------------

sexy2_plotkey <-
  d1 |>
  bind_rows(d2) |>
  ungroup() |>
  select(-sea_name_old, -trt_name_old) |>
  arrange(sea_name, block, plot)

usethis::use_data(sexy2_plotkey, overwrite = TRUE)

sexy2_plotkey %>%
  write_csv("inst/extdata/sexy2_plotkey.csv")
