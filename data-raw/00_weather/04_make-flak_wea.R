#--purpose: use DMI data
#--created: 14 aug 2026
#--notes: Curious if nasa power stuff is ok

rm(list = ls())

library(tidyverse)

flak_wea <- read_csv("data-raw/00_weather/flak_wea_dmi.csv")

flak_wea |>
  write_csv("inst/extdata/flak_wea.csv")

usethis::use_data(flak_wea, overwrite = TRUE)


# totals ------------------------------------------------------------------

flak_weatot <-
  flak_wea |>
  group_by(station, year) |>
  summarise(tot_p = max(psum),
            tot_heatunits = max(tsum0))


flak_weatot |> write_csv("inst/extdata/flak_weatot.csv")

usethis::use_data(flak_weatot, overwrite = TRUE)


# long term values --------------------------------------------------------

#--cumulative precip
#--looks fine
flak_wea |>
  mutate(hilight = ifelse(year == 2025, "yes", "no")) |>
  ggplot(aes(doy, psum, color = hilight, group = year)) +
  geom_line()

#--get long term mean
d_psum_lt <-
  flak_wea |>
  filter(doy < 366) |>
  filter(year < 2024) |> #--30 years
  group_by(doy) |>
  summarise(psum_lt = mean(psum, na.rm = T))

#--looks fine
d_psum_lt|>
  ggplot(aes(doy, psum_lt)) +
  geom_point()

#--heat units, get lt mean
d_cgdd <-
  flak_wea |>
  filter(year < 2024) |>
  group_by(doy) |>
  summarise(tsum0_lt = mean(tsum0, na.rm = T))

#-looks fine
d_cgdd |>
  ggplot(aes(doy, tsum0_lt)) +
  geom_line()

#--put together
d_lt <-
  flak_wea |>
  select(station, doy) |>
  distinct() |>
  left_join(d_psum_lt) |>
  left_join(d_cgdd)

flak_weacum <- d_lt

flak_weacum |> write_csv("inst/extdata/flak_weacum.csv")

usethis::use_data(flak_weacum, overwrite = TRUE)

