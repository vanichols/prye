#--environmental keys are unique to a location and growing season
#--the growing season extends from crop planting in the fall (even if a crop isn't planted) to just before planting the following year
#--typically oct through oct
#--nitrate leaching is a little tricky bc it has a different season, from june to may, basically

library(readxl)
library(tidyverse)


# field key ------------------------------------------------------------

# field_key - simple text to refer to the field
# field_place - flakkebjerg, foulum, etc
# field_number - for flakkebjerg
# field_lat - latitude to make it easy to make a map
# field_lon - longitude ot make it easy to make a map
# field_country - the country, who knows could have more than one someday!

#--add a new row when I add a field

a1 <-
  tribble(
  ~ field_id,    ~field_place,      ~field_number,     ~field_lat,  ~field_lon,   ~field_country,
  "eusun1",   "foulum",              "unknown",          56.496272, 9.601220,  "Denmark",
  "sexy1",   "flakkebjerg",           "22",              55.324979, 11.394706,  "Denmark",
  "sexy2",   "flakkebjerg",           "06",              55.325846, 11.386327,  "Denmark",
  "seed1",   "flakkebjerg",           "19",              55.331113, 11.385372,  "Denmark",
  "clim1",   "flakkebjerg",            "37",             55.316281, 11.388394,   "Denmark",
  "cents",   "flakkebjerg",            "xx",             55.327832, 11.381913,   "Denmark")

prye_fieldkey <- a1

usethis::use_data(prye_fieldkey, overwrite = TRUE)

prye_fieldkey %>%
  write_csv("inst/extdata/prye_fieldkey.csv")
