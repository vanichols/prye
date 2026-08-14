#--purpose: use nasapower package to get ag community data
#--created: 14 aug 2026
#--notes: I found the DMI data very hard to process/access

library(tidyverse)
library(nasapower)



# 1. flakkebjerg in general -----------------------------------------------


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

wea_flak <-
  flak24 |>
  bind_rows(flak25)


# write ----------------------------------------------------------------

sexy_wea <- wea_flak

usethis::use_data(sexy_wea, overwrite = TRUE)
