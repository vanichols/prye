#--environmental keys are unique to a location and growing season
#--the growing season extends from crop planting in the fall (even if a crop isn't planted) to just before planting the following year
#--typically oct through oct
#--nitrate leaching is a little tricky bc it has a different season, from june to may, basically

library(readxl)
library(tidyverse)


# location key ------------------------------------------------------------

# loc_key - character two digits
# loc_id - simple text to refer to the location
# loc_desc - the research site (right now just foulum or flakkeberjg)
# loc_fieldnum - for flakkebjerg
# loc_lat - latitude to make it easy to make a map
# loc_lon - longitude ot make it easy to make a map
# loc_country - the country, who knows could have more than one someday!

#--add a new row when I add a location

a1 <-
  tribble(
  ~loc_key,  ~ loc_id,    ~loc_desc,      ~loc_fieldnum,     ~loc_lat,  ~loc_lon,   ~loc_country,
  "00",         "eusun1",   "foulum",     "unknown",          56.496272, 9.601220,  "Denmark",
  "01",         "sexy1",   "flakkebjerg",  "22",              55.324979, 11.394706,  "Denmark",
  "02",         "sexy2",   "flakkebjerg",  "06",              55.325846, 11.386327,  "Denmark",
  "03",         "seed1",   "flakkebjerg",  "19",              55.331113, 11.385372,  "Denmark",
  "04",         "clim1",   "flakkebjerg",   "37",             55.316281, 11.388394,   "Denmark")

prye_lockey <-
  a1

usethis::use_data(prye_lockey, overwrite = TRUE)

prye_lockey %>%
  write_csv("inst/extdata/prye_lockey.csv")
