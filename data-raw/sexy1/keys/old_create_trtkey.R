#--last updated 25 may 2026

#--made two separate datasets
#--op_trtkey, simple
#--op_trtkeydetailed with row spacing, etc.
#--add fertilizer info (when known, sexy1 and seed increase are all I know right now)

library(readxl)
library(tidyverse)

rm(list = ls())


# trt_key (must be unique to each location)
# loc_key
# sea_key
# trt_desc (details)
# crop_id (p, a, mix)
# cctrt_name (none, fall mix, NA)
# cropplantingrate_kgha
# cropplanting_desc (what was target plants per m2, etc)
# row widths, planting depth, planting date
# bio1date_ymd (if biomass was harvested, I think eusun did)
# hdate_ymd (grain harvest date)

#--I don't think I want the details of the treatments kept here,
#--they could differ depending on the trial...


# 1. raw data -------------------------------------------------------------

#--sexy1, handmade
d1 <-
  read_excel("data-raw/sexy1/keys/sexy1-2024_eukey.xlsx", skip = 5) |>
  select(trt_name) |>
  filter(!is.na(trt_name)) |>
  distinct()


d2 <-
  d1 |>
  mutate(
    loc_key = "sexy1",
  sea_key = "24/25",
  trt_key = paste0(loc_key, "_", sea_key, "_", trt_name))


# 2. add trt_desc -------------------------------------------------------

d3 <-
  d2 |>
  mutate(trt_desc = case_when(
    trt_name == "p" ~ "Perennial cereal (PC) rye in 12.5 cm rows",
    trt_name == "xp" ~ "PC rye in 12.5 cm rows without weed control",
    trt_name == "pcc" ~ "PC rye in 12.5 cm rows with a cover crop planted after grain harvest",
    trt_name == "xpcc" ~ "PC rye in 12.5 cm rows with a cover crop planted after grain harvest without weed control",

    trt_name == "a" ~ "Annual cereal rye hybrid (A) planted in 12.5 cm rows",
    trt_name == "xa" ~ "A planted in 12.5 cm rows without weed control",
    trt_name == "acc" ~ "A planted in 12.5 cm rows with a cover crop planted after grain harvest",
    trt_name == "xacc" ~ "A planted in 12.5 cm rows with a cover crop planted after grain harvest without weed control",

    trt_name == "aprows" ~ "P and A planted in alternating 12.5 cm rows",
    trt_name == "xaprows" ~ "P and A planted in alternating 12.5 cm rows without weed control",
    trt_name == "apmix" ~ "P and A mixture planted in 12.5 cm rows",
    trt_name == "xapmix" ~ "P and A mixture planted in 12.5 cm rows without weed control"))

# 3. add crop_id -------------------------------------------------------

#--make a crop_id (a, p, mix)

d4 <-
  d3 |>
  mutate(crop_id = case_when(
    trt_name == "p" ~ "p",
    trt_name == "xp" ~ "p",
    trt_name == "pcc" ~ "p",
    trt_name == "xpcc" ~ "p",

    trt_name == "a" ~ "a",
    trt_name == "xa" ~ "a",
    trt_name == "acc" ~ "a",
    trt_name == "xacc" ~ "a",

    trt_name == "aprows" ~ "mixrows",
    trt_name == "xaprows" ~ "mixrows",
    trt_name == "apmix" ~ "mixbulk",
    trt_name == "xapmix" ~ "mixbulk"))



# 4. make a cctrt_name ------------------------------------------------------

#--make a cctrt_name (nocc, fcc)


d5 <-
  d4 |>
  mutate(
    cctrt_name = case_when(
      trt_name %in% c("p", "xp", "a", "xa", "apmix", "xapmix", "aprows", "xaprows") ~ "none",
      trt_name %in% c("pcc", "xpcc", "acc", "xacc") ~ "fall mix")
  )



# 5. account for multiple species plantings in a treatment -----------------------------------------------------------

d6 <-
  d5 %>%
  mutate(
    species = case_when(
      crop_id == "p" ~ "perennial rye",
      crop_id == "a" ~ "annual rye",
      crop_id == "mixrows" ~ "perennial rye, annual rye",
      crop_id == "mixbulk" ~ "perennial rye, annual rye")
  ) |>
  separate_rows(species, sep = ",") |>
  mutate(species = str_trim(species))


# 6. planting rate of each species ----------------------------------------

d6 |>
  mutate(
    species_plantingrate_kgha = case_when(
      trt_name %in% c("p", "xp", "pcc", "xpcc") & species == "perennial rye" ~ 94,
      trt_name %in% c("a", "xa", "acc", "xacc") & species == "annual rye" ~ 132,
    trt_name %in% c("xaprows", "aprows", "xapmix", "apmix") & species == "perennial rye" ~ 94/2,
    trt_name %in% c("xaprows", "aprows", "xapmix", "apmix") & species == "annual rye" ~ 132/2,
    TRUE ~ 9999)
    )


# 6. planting desc --------------------------------------------------------

d6 <-
  d5 %>%
  mutate(planting_desc = case_when(
    env_key == "0101" & crop_id == "p" ~ "Aimed for 300 pl m-2 (1 kg perennial rye contains more seeds than 1 kg annual rye)",
    env_key == "0101" & crop_id == "a" ~ "Aimed for 300 pl m-2",
    env_key == "0101" & crop_id == "mixrows" ~ "Aimed for 300 pl m-2, 1.4 kg perennial rye for every 1 kg annual rye",
    env_key == "0101" & crop_id == "mixbulk" ~ "Aimed for 300 pl m-2, 1.4 kg perennial rye for every 1 kg annual rye",

    env_key == "0202" & crop_id == "p" ~ "Aimed for 250 pl m-2",
    env_key == "0202" & crop_id == "a" ~ "Aimed for 250 pl m-2",
    env_key == "0202" & crop_id == "mixrows" ~ "Aimed for 250 pl m-2",
    env_key == "0202" & crop_id == "mixbulk" ~ "Aimed for 250 pl m-2",

    trt_key == "0001_17West" & trt_key == "0001_18West" ~ "Aimed for 100 pl m-2",
    trt_key == "0001_17East" & trt_key == "0001_18East" ~ "Aimed for 300 pl m-2",

    env_key == "0301" ~ "Aimed for 300 pl m-2",
    env_key == "0302" ~ "Aimed for 300 pl m-2",

    TRUE ~ "XX"
  ))


# 7. row widths -----------------------------------------------------------

#--unsure about Eusun's row spacing, may have differed by trt? EMAILED CASANDRA on 12 dec 2025

d7 <-
  d6 %>%
  mutate(rowspacing_cm = case_when(
    env_key %in% c("0101", "0202") ~ 12.5,
    env_key %in% c("0301", "0302") ~ 25,
    trt_key == "0001_17West" ~ 9999,
    trt_key == "0001_18West" ~ 9999,
    trt_key == "0001_17East" ~ 9999,
    trt_key == "0001_18East" ~ 9999,
    TRUE ~ NA)
  )


# 8. planting depth -----------------------------------------------------------
#--Confirming with anders and eusun if planted at 3pm depth

d8 <-
  d7 %>%
  mutate(plantingdepth_cm = 3)



# 9. planting dates ----------------------------------------------------------

d9 <-
  d8 %>%
  mutate(pdate_ymd = case_when(
    env_key == "0101" ~ ymd("2024-10-18"), #--sexy1
    env_key == "0301" ~ ymd("2024-10-18"), #--seed inc 1st year
    env_key == "0202" ~ ymd("2025-09-26"), #--sexy2
    env_key == "0302" ~ ymd("2025-09-25"), #--seed inc 2nd year
    env_key == "0001" ~ ymd("2024-12-31"), #--ask casandra
    TRUE ~ ymd("2999-01-01")))


# 10. biomass harvest date(s) ----------------------------------------------------------

d10 <-
  d9 %>%
  mutate(bio1date_ymd = case_when(
    env_key == "0101" ~ NA, #--sexy1
    env_key == "0301" ~ NA, #--seed inc 1st year
    env_key == "0202" ~ NA, #--sexy2
    env_key == "0302" ~ NA, #--seed inc 2nd year
    env_key == "0001" ~ ymd("2025-05-31"), #--ask casandra, this is just a guess
  TRUE ~ ymd("2999-01-01")
    ))

# 11. grain harvest date ----------------------------------------------------------

d11 <-
  d10 %>%
  mutate(hdate_ymd = case_when(
    env_key == "0101" & crop_id %in% c("a", "acc", "xa", "xacc") ~
      ymd("2025-08-08"), #--sexy1, annual
    env_key == "0101" & !(crop_id %in% c("a", "acc", "xa", "xacc")) ~
      ymd("2025-08-14"), #--sexy1, perennial and mixes
    env_key == "0301" ~ ymd("2025-08-15"), #--seed inc 1st year
    env_key == "0202" ~ NA, #--sexy2
    env_key == "0302" ~ NA, #--seed inc 2nd year
    env_key == "0001" ~ ymd("2025-08-19"), #--ask casandra, this is just a guess
    TRUE ~ ymd("2999-01-01")
  ))



# 12. add herb_id ---------------------------------------------------------

d12 <-
  d11 |>
  separate(trt_key, into = c("xx", "trt_name"), remove = F) |>
  select(-xx) |>
  select(trt_name, everything()) |>
  mutate(herb_id = case_when(
    trt_name %in% c("a", "p", "apmix", "aprows", "acc", "pcc") ~ "herbicide",
    trt_name %in% c("xa", "xp", "xapmix", "xaprows", "xacc", "xpcc") ~ "none",
    TRUE ~ "UHOH")
  )

# 13. add fert_amount and fert_description ---------------------------------------------------------

#--right now all of the plots got the same fertilizer app
#--

d13 <-
  d12 |>
  mutate(fert_kgha = case_when(
    env_key == "0101" ~ NA, #--sexy1
    env_key == "0301" ~ NA, #--seed inc 1st year
    env_key == "0202" ~ NA, #--sexy2
    env_key == "0302" ~ NA, #--seed inc 2nd year
    env_key == "0001" ~ ymd("2025-05-31"), #--ask casandra, this is just a guess
    TRUE ~ ymd("2999-01-01")
  )) |>
  mutate(fert_description = case_when(
    env_key == "0101" ~ NA, #--sexy1
    env_key == "0301" ~ NA, #--seed inc 1st year
    env_key == "0202" ~ NA, #--sexy2
    env_key == "0302" ~ NA, #--seed inc 2nd year
    env_key == "0001" ~ ymd("2025-05-31"), #--ask casandra, this is just a guess
    TRUE ~ ymd("2999-01-01")
  ))


# done --------------------------------------------------------------------

op_trtkeydetails <-
  d13 |>
  select(env_key, trt_key, trt_desc, trt_name, crop_id, herb_id,
         everything())

usethis::use_data(op_trtkeydetails, overwrite = TRUE)

op_trtkey <-
  op_trtkeydetails |>
  select(env_key, trt_key, trt_name, crop_id, herb_id, cctrt_name)

usethis::use_data(op_trtkey, overwrite = TRUE)

