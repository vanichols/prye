# sexy samples have their own keys in that folder
rm(list = ls())

#--for formatting reference:
sexy_eukey <- read_csv("inst/extdata/sexy_eukey.csv")

# make one for eusun's plots using the same format! Need to do....


# ###############eusun1-24/25 ----------------------------------------------

#--the plots have different treatments
#--so a plot is not a unit that contains a uniform treatment
#--rename the plots
#--the treatments are nonsense, make them more sensical!!!!

e1 <-
  read_excel("data-raw/eusun/keys/Eusun-treatments-from-Casandra.xlsx", sheet = "Grain", skip = 2) |>
  janitor::clean_names() |>
  select(plotraw = plot, treatment) |>
  #--make the plot unique for each treatment
  separate(treatment, into = c("xx", "plotinfo"), remove = F)

#--assign the plots to blocks
e2 <-
  e1 |>
  mutate(plot_nu = case_when(
    plotraw %in% c(8, 55) ~ plotraw + 400, #--block 4
    plotraw %in% c(13, 69) ~ plotraw + 300, #--block 3
    plotraw %in% c(4, 3) ~ plotraw + 200, #--block 2
    plotraw %in% c(26, 66) ~ plotraw + 100, #--block 1
    TRUE ~ 999999
  ))

#--make the plot ids unique for a treatment
e3 <-
  e2 |>
  mutate(
    plotinfo = str_sub(plotinfo, 1, 1),
    plot_id = paste0(plot_nu, plotinfo)
  ) |>
  select(plot_id, treatment)


#--the trt_id is nonsense, fix that at some point
e4 <-
  e3 |>
  mutate(
    loc_key = "00", #--eusun1
    sea_key = "24/25",
    trt_id = str_remove(treatment, "_"),
    eu_key = paste(loc_key, sea_key, trt_id, plot_id, sep = "_"))  |>
  select(eu_key) |>
  distinct()

e5 <-
  e4 |>
  separate(eu_key, into = c("loc_key", "sea_key", "trt_id", "plot_id"), sep = "_", remove = F)

#--replace loc_key with loc_id for ease in viewing
all <- read_csv("inst/extdata/prye_lockey.csv")

e6 <-
  e5 |>
  left_join(all) |>
  select(eu_key, loc_id, sea_key, trt_id, plot_id)


eusun_eukey <- e6

usethis::use_data(eusun_eukey, overwrite = TRUE)

eusun_eukey %>%
  write_csv("inst/extdata/eusun_eukey.csv")

