#--purpose: use nasapower package to get ag community data
#--created: 14 aug 2026
#--notes: I found the DMI data very hard to process/access

rm(list = ls())

library(tidyverse)


wea <- read_csv("inst/extdata/flak_wea.csv")


# totals ------------------------------------------------------------------

flak_weatot <-
  wea |>
  mutate(T2M_new = ifelse(T2M < 0, 0, T2M)) |>
  group_by(YEAR) |>
  summarise(tot_prec = sum(PRECTOTCORR, na.rm = T),
            tot_heatunits = sum(T2M_new))


flak_weatot |> write_csv("inst/extdata/flak_weatot.csv")

usethis::use_data(flak_weatot, overwrite = TRUE)



# cumulatiave totals ------------------------------------------------------

#--cumulative precip
d_cp <-
  wea |>
  select(YEAR, MM, DD, DOY, YYYYMMDD, PRECTOTCORR) |>
  arrange(YYYYMMDD) |>
  group_by(YEAR) |>
  mutate(cprecip = cumsum(PRECTOTCORR))

#--looks fine
d_cp |>
  mutate(hilight = ifelse(YEAR == 2025, "yes", "no")) |>
  ggplot(aes(DOY, cprecip, color = hilight, group = YEAR)) +
  geom_line()

#--get long term mean
d_cplt <-
  d_cp |>
  group_by(DOY) |>
  summarise(cpreciplt = mean(cprecip, na.rm = T))

#--looks fine
d_cplt|>
  ggplot(aes(DOY, cpreciplt)) +
  geom_point()

# cumulative GDDs with base 0 temp ------------------------------------------------------

d_cgdd <-
  wea |>
  select(YEAR, MM, DD, DOY, YYYYMMDD, T2M, T2M_MAX, T2M_MIN) |>
  mutate(T2M_new = ifelse(T2M < 0, 0, T2M)) |>
  arrange(YYYYMMDD) |>
  group_by(YEAR) |>
  mutate(cgdd = cumsum(T2M_new))

#--looks fine
d_cgdd |>
  mutate(hilight = ifelse(YEAR == 2025, "yes", "no")) |>
  ggplot(aes(DOY, cgdd, color = hilight, group = YEAR)) +
  geom_line()

d_cgddlt <-
  d_cgdd |>
  group_by(DOY) |>
  summarise(cgddlt = mean(cgdd, na.rm = T))


d_cgddlt|>
  ggplot(aes(DOY, cgddlt)) +
  geom_line() +
  geom_line(data = d_cgdd |> filter(YEAR == 2025),
            aes(x = DOY, y = cgdd), color = "red")

#--put together
d_lt <-
  wea |>
  select(LON, LAT, DOY) |>
  distinct() |>
  left_join(d_cplt) |>
  left_join(d_cgddlt)


flak_weacum <- d_lt

flak_weacum |> write_csv("inst/extdata/flak_weacum.csv")

usethis::use_data(flak_weacum, overwrite = TRUE)

