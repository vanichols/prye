library(readxl)
library(tidyverse)

#--eukey refers to a location, season, and plot
#--the plot 'part' is ignored here, it is included in measurements where that is relevant

# ###############sexy1-24/25 ----------------------------------------------

#--this 2024_eukey document was created by hand

a1 <-
  read_excel("data-raw/sexy/keys/sexy1-2024_eukey.xlsx", skip = 5) |>
  fill(trt_id) |>
  mutate(loc_key = "01",  #--sexy1
         sea_key = "24/25",
         eu_key = paste(loc_key, sea_key, trt_id, plot, sep = "_"))  |>
  select(eu_key) |>
  distinct()

#--add a bit more info to make it clear what the key is comprised of
#--id means it is not a unique value universally
#--key means it shuld be a unique value universally

a2 <-
  a1 |>
  separate(eu_key, into = c("loc_key", "sea_key", "trt_id", "plot_id"), sep = "_", remove = F)


# ###############sexy2-25/26 ----------------------------------------------

b1 <-
  read_excel("data-raw/sexy/keys/sexy2-2025_eukey.xlsx", skip = 5) %>%
  mutate(loc_key = "02",
         sea_key = "25/26",
         eu_key = paste(loc_key, sea_key, trt, plot, sep = "_")) %>%
  select(eu_key) |>
  distinct()

b2 <-
  b1 |>
  separate(eu_key, into = c("loc_key", "sea_key", "trt_id", "plot_id"), sep = "_", remove = F)


# make data ---------------------------------------------------------------

f1 <-
  a2 |>
  bind_rows(b2)

#--replace loc_key with loc_id for ease in viewing
all <- read_csv("inst/extdata/prye_lockey.csv")

f2 <-
  f1 |>
  left_join(all) |>
  select(eu_key, loc_id, sea_key, trt_id, plot_id)

sexy_eukey <- f2

usethis::use_data(sexy_eukey, overwrite = TRUE)

sexy_eukey %>%
  write_csv("inst/extdata/sexy_eukey.csv")
