# created           nov 2026
# purpose:          process machine grain and straw yields from sexy2
# last updated:
# notes:            using the raw files from Ander's O-drive

library(tidyverse)
library(readxl)
library(lubridate)

rm(list = ls())

#--doesn't hold it's character for plot, ok...
sexy2_plotkey <-
  read_csv("inst/extdata/sexy2_plotkey.csv") |>
  filter(sea_name == "25/26")

#--field_id
#--sea_name
#--trt_name
#--block
#--plot
#--data_type (machine_grain_Mgha, machine_straw_Mgha)
#--value

#--whether it is 2.4 or 2.5 is a bit of a philosophical debate...
plot_size_ha <- 2.4 * 10 / 10000



# grain data --------------------------------------------------------------

#--grain moisture and protein
g1 <-
  read_excel("data-raw/sexy2/yields_machine/raw-from-Odrive/Nit and TKV/Sexy 2-2 Nit.xlsx") |>
  janitor::clean_names()

#--extract plot number from that garbled thing
g2 <-
  g1 |>
  mutate(plot = as.numeric(str_extract(sample_id, "(?<=_)\\d+(?=\\.)"))) |>
  filter(!is.na(plot))

g2 |>
  select(plot) |>
  distinct()

#--dry protein is missing, have to calculate it myself
#--take average of the two plots
g3 <-
  g2 |>
  mutate(dryprotein_pct = predicted_protein_as_is_percent * (1-predicted_vand_percent/100)) |>
  select(plot,
         grainmoisture_pct = predicted_vand_percent,
         dryprotein_pct) |>
  arrange(plot) |>
  summarise(.by = "plot",
            grainmoisture_pct = mean(grainmoisture_pct, na.rm = T),
            dryprotein_pct = mean(dryprotein_pct, na.rm = T))

#--plots 107 and 411 are missing
missing_plots <-
  sexy2_plotkey |>
  select(plot, trt_name) |>
  left_join(g3) |>
  filter(is.na(grainmoisture_pct)) |>
  select(plot, trt_name)

#--take average of other treatments
g3_missing <-
  sexy2_plotkey |>
  select(plot, trt_name) |>
  left_join(g3) |>
  summarise(.by = "trt_name",
            grainmoisture_pct = mean(grainmoisture_pct, na.rm = T),
            dryprotein_pct = mean(dryprotein_pct, na.rm = T)) |>
  right_join(missing_plots) |>
  select(-trt_name)

g4 <-
  g3 |>
  bind_rows(g3_missing) |>
  arrange(plot)

#--tkw, wasn't measured for every plot, apparently
t1a <-
  read_excel("data-raw/sexy2/yields_machine/raw-from-Odrive/Nit and TKV/Sexy 2-2_TKV.xlsx",
             sheet = "Annual") |>
  janitor::clean_names()

t1b <-
  read_excel("data-raw/sexy2/yields_machine/raw-from-Odrive/Nit and TKV/Sexy 2-2_TKV.xlsx",
             sheet = "Perennial") |>
  janitor::clean_names() |>
  mutate(x250_kernels = as.character(x250_kernels))

t1 <-
  t1a |>
  bind_rows(t1b)

#--average over plots
t2 <-
  t1 |>
  mutate(plot = round(plot, 0)) |>
  summarise(.by = c("plot"), tkw_g = mean(tkv, na.rm = T)) |>
  filter(!is.na(plot)) |>
  arrange(plot)

#--ready to merge format
grainthings <-
  g4 |>
  left_join(t2) |>
  arrange(plot)

#--check, looks ok
grainthings |>
  pivot_longer(2:4) |>
  ggplot(aes(value)) +
  geom_histogram() +
  facet_wrap(~name, scales = "free")


# straw data --------------------------------------------------------------
#--from Emma's package

s1 <-
  read_csv("data-raw/sexy2/yields_machine/raw-from-Odrive/straw_dry_content_sexy2.csv") |>
  mutate(straw_moisture_pct = 1 - dry_prop) |>
  select(trt_name = trt_id, straw_moisture_pct)

# grain and straw yields --------------------------------------------------

#--annual
a0 <-
  read_excel("data-raw/sexy2/yields_machine/raw-from-Odrive/Annual Rye/2026 Annual harvest_Sexy rye 2.xlsx") |>
  janitor::clean_names()

#--perennial
p0 <-
  read_excel("data-raw/sexy2/yields_machine/raw-from-Odrive/Perennial Rye/Sexy 2-2 Perennial harvest.xlsx") |>
  janitor::clean_names()

d <-
  a0 |>
  bind_rows(p0) |>
  arrange(plot)

# 1. keep only yield side of plot ------------------------------

d1 <-
  d |>
  filter(yield_destruction == "Y")


# 2. rename subplots north and south --------------------------------------

d2 <-
  d1 |>
  mutate(sub_plot = ifelse(subplot %in% c(1, 3), "north", "south"))


# 3. get harvest date -----------------------------------------------------

d3 <-
  d2 |>
  separate(date_time, sep = " ", into = c("date", "time")) |>
  mutate(harvest_date = dmy(date))

d3 |>
  select(harvest_date) |>
  distinct()

# 4. change units ----------------------------------------------------------

d4 <-
  d3 |>
  select(harvest_date, trt_name = name, plot, sub_plot,
         machine_wetgrain_Mgha = grain_weight_kg,
         machine_wetstraw_Mgha = straw_weight_kg) |>
  pivot_longer(machine_wetgrain_Mgha:machine_wetstraw_Mgha) |>
  mutate(value = value / plot_size_ha / 1000) #--kg per ha * 1 Mg/1000 kg


d4 |>
  ggplot(aes(trt_name, value)) +
  geom_jitter() +
  facet_grid(.~name) +
  coord_flip()

#--there is one 0 in xpcc, both straw and grain
d4 |>
  filter(trt_name %in% c("xpcc"))

#--remove the plots with 0s
d4_new <-
  d4 |>
  filter(!(trt_name == "xpcc" & plot == 204 & sub_plot == "north"))

d4_new |>
  ggplot(aes(trt_name, value)) +
  geom_jitter() +
  facet_grid(.~name) +
  coord_flip()


# 5. take means of two sub plots ------------------------------------------

d5 <-
  d4_new |>
  summarise(.by = c("harvest_date", "trt_name", "plot", "name"), value = mean(value))


# 6. calculate dry grain and straw yields ---------------------------------------------------

#--grain data
d6a <-
  d5 |>
  filter(name == "machine_wetgrain_Mgha") |>
  left_join(grainthings |> select(plot, grainmoisture_pct)) |>
  mutate(machine_drygrain_Mgha = value * (1 - grainmoisture_pct/100)) |>
  select(-name, -value, -grainmoisture_pct)

#--straw data
d6b <-
  d5 |>
  filter(name == "machine_wetstraw_Mgha") |>
  left_join(s1, by = "trt_name") |> #--only have moistures by treatment
  mutate(machine_drystraw_Mgha = value * (1 - straw_moisture_pct/100)) |>
  select(-name, -value, -straw_moisture_pct)


d6 <-
  d6a |>
  left_join(d6b)



# 7. combine datasets ---------------------------------------------------------

d7 <-
  d6 |>
  left_join(grainthings)


# 8. long pivot -----------------------------------------------------------

d8 <-
  d7 |>
  pivot_longer(machine_drygrain_Mgha:tkw_g) |>
  left_join(sexy2_plotkey)


# 9. clean up and add notes?-------------------------------------------------------------

d9 <-
  d8 |>
  select(field_id, sea_name, trt_name, harvest_date, block, plot, name, value) |>
  mutate(notes = ifelse(name == "machine_drystraw_Mgha", "Single pass combine straw harvest", NA))

# write it ----------------------------------------------------------------

sexy2_harvest <-  d9

usethis::use_data(sexy2_harvest, overwrite = TRUE)

sexy2_harvest %>%
  write_csv("inst/extdata/sexy2_harvest.csv")

