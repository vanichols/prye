#--last updated 25 may 2026

library(readxl)
library(tidyverse)

#--eukey refers to a location, season, and plot
#--the plot 'part' is ignored here, it is included in measurements where that is relevant

# ###############sexy2-25/26 ----------------------------------------------

#--this 2025_eukey document was created by hand

a1 <-
  read_excel("data-raw/sexy2/keys/sexy2-2025_eukey.xlsx", skip = 5) |>
  mutate(loc_key = "sexy2",
         sea_key = "25/26",
         trt_id = trt,
         eu_key = paste(loc_key, sea_key, trt_id, plot, sep = "_"))  |>
  select(eu_key) |>
  distinct()

#--add a bit more info to make it clear what the key is comprised of
#--id means it is not a unique value universally
#--key means it shuld be a unique value universally

a2 <-
  a1 |>
  separate(eu_key, into = c("loc_key", "sea_key", "trt_id", "plot_id"), sep = "_", remove = F)


# make data ---------------------------------------------------------------

f1 <- a2

sexy2_eukey <- f1

usethis::use_data(sexy2_eukey, overwrite = TRUE)

sexy2_eukey %>%
  write_csv("inst/extdata/sexy2_eukey.csv")
