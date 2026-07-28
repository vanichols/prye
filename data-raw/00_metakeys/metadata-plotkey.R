# created 28 july 2027
# purpose: keep track of column names and meanings across trials

#--simple:
#     field_id: sexy1
#     sea_name: 24/25
#     block: B1
#     plot: 101
#     trt_name: apmix


meta_plotkey <-
  tibble(
  field_id = "sexy1; see fieldkey for what this links to",
       sea_name = "26/25; this is combined with the field_id to make a sea_id",
       block = "B1; the B is to make it non-numeric in stats models",
       plot = "104; whatever the local plot name is for the trial, it is combined with the field_id to make a plot_id",
       trt_name = "xpcc; whatever the local treatment name is, should be unique within the trial") |>
  pivot_longer(field_id:trt_name) |>
  separate(value, into = c("example", "description"), sep = ";") |>
  mutate(across(
    .cols = where(is.character),   # Select only character columns
    .fns  = str_squish              # Apply str_squish to each
  ))

usethis::use_data(meta_plotkey, overwrite = TRUE)

meta_plotkey %>%
  write_csv("inst/extdata/meta_plotkey.csv")
