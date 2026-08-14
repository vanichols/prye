#--purpose: use nasapower package to get ag community data
#--created: 14 aug 2026
#--notes: I found the DMI data very hard to process/access
#--there is something wrong with the precip data in 2024, unless there was a flood I don't remember happening

rm(list = ls())

library(tidyverse)
library(nasapower)



# 1. flakkebjerg in general -----------------------------------------------


flakLT <- get_power(
  community = "AG",
  lonlat = c(11.39044, 55.32523),
  pars = c(
    "T2M",           # mean air temperature
    "T2M_MAX",       # maximum temperature
    "T2M_MIN",       # minimum temperature
    "RH2M",          # relative humidity
    "PRECTOTCORR",   # precipitation
    "ALLSKY_SFC_SW_DWN", # solar radiation
    "WS2M"            # wind speed
  ),
  dates = c("1993-01-01", "2023-12-31"),
  temporal_api = "daily"
)

flak24 <- get_power(
  community = "AG",
  lonlat = c(11.39044, 55.32523),
  pars = c(
    "T2M",           # mean air temperature
    "T2M_MAX",       # maximum temperature
    "T2M_MIN",       # minimum temperature
    "RH2M",          # relative humidity
    "PRECTOTCORR",   # precipitation
    "ALLSKY_SFC_SW_DWN", # solar radiation
    "WS2M"            # wind speed
  ),
  dates = c("2024-01-01", "2024-12-31"),
  temporal_api = "daily"
)

flak25 <- get_power(
  community = "AG",
  lonlat = c(11.39044, 55.32523),
  pars = c(
    "T2M",           # mean air temperature
    "T2M_MAX",       # maximum temperature
    "T2M_MIN",       # minimum temperature
    "RH2M",          # relative humidity
    "PRECTOTCORR",   # precipitation
    "ALLSKY_SFC_SW_DWN", # solar radiation
    "WS2M"            # wind speed
  ),
  dates = c("2025-01-01", "2025-12-31"),
  temporal_api = "daily"
)

d <-
  flakLT |>
  bind_rows(flak24) |>
  bind_rows(flak25)



# check it ----------------------------------------------------------------

d2 <-
  d #|>
  #filter(YEAR != 2024) |>  #--there is something weird here in the precip data
  #filter(DOY < 366) #--leap years

# write ----------------------------------------------------------------

flak_wea_nasa <- d2

flak_wea_nasa |>
  write_csv("data-raw/00_weather/flak_wea_nasa.csv")
