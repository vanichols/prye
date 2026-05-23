# sexy samples have their own keys in that folder

# make one for eusun's plots using the same format! Need to do....


# ###############eusun1-24/25 ----------------------------------------------

#--the plots have different treatments
#--so a plot is not a unit that contains a uniform treatment
#--rename the plots

e1 <-
  read_excel("data-raw/keys/Eusun-treatments-from-Casandra.xlsx", sheet = "Grain", skip = 2) |>
  janitor::clean_names() |>
  select(plot_id = plot, treatment) |>
  #--make the plot unique for each treatment
  separate(treatment, into = c("xx", "plotinfo"), remove = F) |>
  mutate(
    plotinfo = str_sub(plotinfo, 1, 1),
    plot_nu = plot_id,
    plot_id = paste0(plot_id, plotinfo)
  ) |>
  select(-xx, -plotinfo) |>
  mutate(
    env_key = "0001",
    trt_id = str_remove(treatment, "_"),
    trt_key = paste0(env_key, "_", trt_id)) |>
  select(trt_key, plot_id, plot_nu) |>
  #--based on the plot map he shared
  mutate(block_id = case_when(
    plot_nu %in% c(8, 55) ~ "b4",
    plot_nu %in% c(13, 69) ~ "b3",
    plot_nu %in% c(4, 3) ~ "b2",
    plot_nu %in% c(13, 69) ~ "b1",
    TRUE ~ "UHOH"
  )) |>
  select(-plot_nu) |>
  mutate_all(as.character)

