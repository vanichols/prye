#--purpose: use https://agro-web11t.uni.au.dk/klimadb/
#--created: 14 aug 2026

rm(list = ls())

library(tidyverse)
library(lubridate)



# 1993 through 2013 -------------------------------------------------------

#--the NA comes from a null min minte, so that is fine, we don't use minte
dmi1 <-
  read_csv2("data-raw/00_weather/DMI-Flakkebjerg/AGRO - FLAK 19930101 through 20131231.csv")


dmi1 |>
  mutate(minte2 = as.numeric (minte)) |>
  filter(is.na(minte2))

dmi1_final <-
  dmi1 |>
  mutate_if(is.character, as.numeric) |>
  rename(prec = prec08)

dmi1_final |>
  mutate(DOY = yday(date)) |>
  ggplot(aes(DOY, prec)) +
  geom_point()

# 2014 - 2023 -------------------------------------------------------

dmi2 <-
  read_csv2("data-raw/00_weather/DMI-Flakkebjerg/AGRO - FLAK 20140101 through 20231231.csv") |>
  mutate(date = as_date(date, format = "%d/%m/%Y")) |>
  mutate_if(is.character, as.numeric)


# 2024+ -------------------------------------------------------------------

dmi3 <-
  read_csv2("data-raw/00_weather/DMI-Flakkebjerg/AGRO - FLAK 20240101 through 20251213 - full.csv") |>
  mutate(date = as_date(date, format = "%d/%m/%Y"))



# combine and clean up ----------------------------------------------------

wea1 <-
  dmi1_final |>
  bind_rows(dmi2) |>
  bind_rows(dmi3)


wea2 <-
  wea1 |>
  separate(date, into = c("year", "month", "day"), remove = F) |>
  mutate(doy = yday(date),
         station = "FLAKKEBJERG") |>
  select(station, date, day, month, year, doy, everything())

wea3 <-
  wea2 |>
  arrange(date) |>
  group_by(year) |>
  mutate(psum = cumsum(prec)) |>
  rename(te = temp)

flak_wea_dmi <- wea3

flak_wea_dmi |> write_csv("data-raw/00_weather/flak_wea_dmi.csv")


