
#--copied from old


# ###############seed1-24/25 ----------------------------------------------

#--the seed increase field, no plots just one big spot with 7 passes

c1 <-
  tibble(plot_id = c(1,2, 3, 4, 5, 6, 7),
         trt_key = rep("0301_pmechwide24", 7),
         block_id = NA) |>
  mutate_all(as.character)

# ###############seed1-25/26 ----------------------------------------------

#--the seed increase field, tilled up every other one...don't remember how many plots

d1a <-
  tibble(
    plot_id = c(1, 3, 5),
    trt_key = rep("0302_pmechwide25", 3))

d1b <-
  tibble(
    plot_id = c(2, 4, 6, 8),
    trt_key = rep("0302_pmechwide24", 4))


d1 <-
  d1a |>
  bind_rows(d1b) |>
  mutate(block_id = NA) |>
  mutate_all(as.character)
