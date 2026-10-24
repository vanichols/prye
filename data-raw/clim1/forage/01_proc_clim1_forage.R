#--created: july 2026
#--purpose: process the 2026 cadillac biomass harvest and separation anders and cecilie did

#--last updated:


library(tidyverse)
library(readxl)

rm(list = ls())


clim1_plotkey <- read_csv("inst/extdata/clim1_plotkey.csv")

# 0. raw data -------------------------------------------------------------

raw1 <- read_excel("data-raw/clim1/forage/2026-07-21_Climax Forage harvest-manual.xlsx",
                   sheet = "hand",
                   skip = 5) |>
  mutate(sampledate_ymd = "2026-07-21")

raw2 <- read_excel("data-raw/clim1/forage/2026-10-15_Climax Forage harvest-manual.xlsx",
                   sheet = "hand",
                   skip = 5) |>
  mutate(sampledate_ymd = "2026-10-15")


raw <-
  raw1 |>
  bind_rows(raw2)


# 1. clean names ----------------------------------------------------------

d1 <-
  raw |>
  janitor::clean_names()


# 2. look at treatments make sure they match ------------------------------

trts <- clim1_plotkey |> select(plot, trt_name)

trts |>
  filter(plot == 314)

d1 |>
  filter(plot == 314)

#--they match, great

d2 <-
  d1 |>
  select(-name, -trt_name)

# 3. long form ----------------------------------------------------------------

d3 <-
  d2 |>
  left_join(clim1_plotkey) |>
  select(field_id, block, plot, trt_name, sampledate_ymd, perennial_rye, companion_crop, weeds) |>
  pivot_longer(perennial_rye:weeds) |>
  mutate(data_type = "forage_g_m2") |>
  rename(biomass_cat = name)


# 4. NAs are zeros in this case -------------------------------------------

d4 <-
  d3 |>
  mutate(value = ifelse(is.na(value), 0, value),
         sampledate_ymd = ymd(sampledate_ymd))


# 5. explicit zeros -------------------------------------------------------

#--the 26s_pw1 wasn't harvested at the first date
d5 <-
  d4 |>
  complete(
    nesting(field_id, data_type, trt_name, block, plot),  # keeps each plot's real ID
    sampledate_ymd,
    biomass_cat,
    fill = list(value = 0)
  )

# 5. write it -------------------------------------------------------------

clim1_forage <-
  d5 |>
  mutate(value_kgha = value * 10) |>
  select(field_id, block, plot, trt_name, data_type, sampledate_ymd, biomass_cat, value_kgha)


usethis::use_data(clim1_forage, overwrite = TRUE)

clim1_forage   |>
  write_csv("inst/extdata/clim1_forage.csv")


# look at it --------------------------------------------------------------


clim1_forage |>
  ggplot(aes(trt_name, value_kgha)) +
  geom_col(aes(fill = biomass_cat)) +
  facet_grid(block~sampledate_ymd) +
  coord_flip()

clim1_forage |>
  group_by(sampledate_ymd, trt_name, biomass_cat) |>
  summarise(value = mean(value_kgha)) |>
  ggplot(aes(trt_name, value)) +
  geom_col(aes(fill = biomass_cat), color = "black") +
  coord_flip() +
  facet_grid(.~sampledate_ymd)


# ---------------------------------------------------------------
# clim1 forage biomass: totals by cropping system, with harvest date,
# biomass category, and block-to-block variation
# ---------------------------------------------------------------
library(tidyverse)
library(patchwork)

dat <-
  clim1_forage |>
  mutate(
    sampledate_ymd = as.Date(sampledate_ymd),
    harvest = factor(format(sampledate_ymd, "%b %d"),
                     levels = format(sort(unique(sampledate_ymd)), "%b %d")),
    biomass_cat = factor(biomass_cat,
                         levels = c("perennial_rye", "companion_crop", "weeds"),
                         labels = c("Perennial grain", "Companion crop", "Weeds"))
  )

# ---- Optional: friendlier names for the cropping systems (edit labels) ----
trt_labels <- c("26s_p" = "Perennial rye",
                "26s_pw1" = "Perennial wheat",
                "26s_pleg2wide" = "Wide row perennial rye + perennial legume",
                "26s_pleg1" = "Perennial rye + annual legume",
                "26s_pbuckwide" = "Wide row perennial rye + buckwheat",
                "26s_pbuck" = "Perennial rye + buckwheat")
dat <- dat |> mutate(trt_name = recode(trt_name, !!!trt_labels))

# ---- Colours: hue = category, lightness = harvest ----
cat_cols <- c("Perennial grain" = "#D9A441", "Companion crop" = "#3F8F5B", "Weeds" = "darkblue")
harvests <- levels(dat$harvest)
alpha_vals <- setNames(seq(1, 0.45, length.out = length(harvests)), harvests)

# ---- Block-level totals (sum of all dates and categories) ----
block_tot <- dat |>
  group_by(trt_name, block) |>
  summarise(total = sum(value_kgha), .groups = "drop")

# order cropping systems by mean total
trt_order <- block_tot |>
  group_by(trt_name) |> summarise(m = mean(total)) |>
  arrange(desc(m)) |> pull(trt_name)
dat       <- dat       |> mutate(trt_name = factor(trt_name, trt_order))
block_tot <- block_tot |> mutate(trt_name = factor(trt_name, trt_order))

# ---- Mean of each date x category segment across blocks ----
seg_means <-
  dat |>
  group_by(trt_name, harvest, biomass_cat, block) |>
  summarise(value_kgha = sum(value_kgha), .groups = "drop") |>
  group_by(trt_name, harvest, biomass_cat) |>
  summarise(mean_val = mean(value_kgha), .groups = "drop") |>
  # stacking order: first harvest + rye at the bottom
  mutate(seg = factor(paste(harvest, biomass_cat),
                      levels = rev(paste(rep(harvests, each = 3),
                                         levels(dat$biomass_cat)))))

tot_means <- block_tot |>
  group_by(trt_name) |>
  summarise(mean_total = mean(total), se = sd(total) / sqrt(n()), .groups = "drop")

# ---- Panel A: total biomass, stacked by harvest and category ----
pA <- ggplot() +
  geom_col(data = seg_means,
           aes(trt_name, mean_val, fill = biomass_cat, alpha = harvest, group = seg),
           colour = "white", linewidth = 0.3, width = 0.65) +
  geom_errorbar(data = tot_means,
                aes(trt_name, ymin = mean_total - se, ymax = mean_total + se),
                width = 0.15, linewidth = 0.5) +
  # geom_point(data = block_tot,
  #            aes(trt_name, total, shape = block),
  #            position = position_jitter(width = 0.12, height = 0, seed = 1),
  #            size = 2.2, stroke = 0.7, fill = "white", colour = "grey15") +
  scale_fill_manual(values = cat_cols, name = "Biomass category") +
  scale_alpha_manual(values = alpha_vals, name = "Harvest date") +
  scale_shape_manual(values = c(21, 22, 24, 23), name = "Block") +
  guides(fill  = guide_legend(order = 1, override.aes = list(alpha = 1)),
         alpha = guide_legend(order = 2, override.aes = list(fill = "grey30")),
         shape = guide_legend(order = 3)) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.08))) +
  labs(x = NULL, y = expression("Forage biomass (kg ha"^-2*")"),
       title = "CLIMAX - 2026 total forage harvested",
       subtitle = "Bars = mean of blocks (± SE on total)") +
  theme_classic(base_size = 12) +
  theme(axis.text.x = element_text(angle = 30, hjust = 1, vjust = 1),
        plot.margin = margin(t = 5, r = 10, b = 15, l = 100))

pA

ggsave("data-raw/clim1/clim1_forage_figure.png", width = 9, height = 11, dpi = 300)
