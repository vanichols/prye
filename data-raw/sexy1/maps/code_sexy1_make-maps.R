# created: 7 aug 2026
# purpose: make a nicer map (automated, not powerpoint or excel) to give to anders


rm(list = ls())

library(tidyverse)
library(scales)
library(ggpattern)

theme_set(theme_minimal())

th1 <-
  theme(axis.text.y = element_blank(),
      strip.text = element_text(size = rel(1.2),
                                face = "italic"),
      panel.grid.major.x = element_blank(),
      axis.text.x = element_text(angle = 90, vjust = 0.5))



# 1. sexy1 24/25 --------------------------------------------------------

#--get treatments and build structure
d1 <-
  read_csv("inst/extdata/sexy1_plotkey.csv") |>
  filter(sea_name == "24/25") |>
  mutate(plot = as.character(plot),
         block = str_replace_all(block, "B", "Block "),
         plot_half1 = "A",
         plot_half2 = "B") %>%
  pivot_longer(plot_half1:plot_half2) %>%
  select(-name) %>%
  rename(plot_half = value)


d1 %>%
  mutate(h = 1) %>%
  ggplot(aes(plot, h)) +
  geom_col(fill = "white", color = "black", position = position_dodge()) +
  geom_label(aes(label = trt_name), color = "red4", angle = 90, y = 0.5) +
  scale_y_discrete(expand = c(0.01, 0.01)) +
  facet_wrap(~block, scales = "free", ncol = 2) +
  th1 +
  labs(x = NULL,
       y = NULL,
       title = "SEXY1x1 - 24/25 season",
       caption = paste("Created by Gina\nLast updated:", date()))

ggsave("data-raw/sexy1/maps/sexy1x1_plot-treatments-map.pdf",
       width = 11, height = 8.5)


# 2. sexy1 26/27 --------------------------------------------------------

#--get treatments and build structure
d2 <-
  read_csv("inst/extdata/sexy1_plotkey.csv") |>
  filter(sea_name == "26/27") |>
  mutate(plot = as.character(plot),
         block = str_replace_all(block, "B", "Block "),
         plot_half1 = "A",
         plot_half2 = "B") %>%
  pivot_longer(plot_half1:plot_half2) %>%
  select(-name) %>%
  rename(plot_half = value)


#--treatment map
d2 %>%
  mutate(h = 1) %>%
  ggplot(aes(plot, h)) +
  geom_col(fill = "white", color = "black", position = position_dodge()) +
  geom_label(aes(label = trt_name), color = "red4", angle = 90, y = 0.5) +
  scale_y_discrete(expand = c(0.01, 0.01)) +
  facet_wrap(~block, scales = "free", ncol = 2) +
  th1 +
  labs(x = NULL,
       y = NULL,
       title = "SEXY1x3 - 26/27 season",
       caption = paste("Created by Gina\nLast updated:", date()))

ggsave("data-raw/sexy1/maps/sexy1x3_plot-treatments-map.pdf",
       width = 11, height = 8.5)



#--planting map? useful? Not sure.
load("data/sexy1_trtkey.rda")

d3 <-
  d2 |>
  left_join(sexy1_trtkey |> select(-trt_desc))

#--annual planting map
d3 %>%
  mutate(h = 1) %>%
  mutate(fill_color = ifelse(crop_name %in% c("a", "a, p"), "color", "none"),
         fill_pattern = ifelse(crop_name == "a, p", "pat1", "none")) |>
  ggplot(aes(plot, h)) +
  geom_col_pattern(aes(fill = fill_color, pattern = fill_pattern),
                   color = "black", show.legend = F,
                   pattern_angle = 80) +
  geom_label(data = . %>% filter(crop_name %in% c("a", "a, p")),
             aes(label = trt_name), y = 0.5, color = "red4", angle = 90) +
  scale_y_continuous(limits = c(0, 1), expand = c(0.01, 0.01)) +
  scale_fill_manual(values = c("color" = "skyblue", "none" = "white")) +
  scale_pattern_manual(values = c("pat1" = "stripe", "none" = "none")) +
  facet_wrap(~block, scales = "free", ncol = 2) +
  th1 +
  labs(x = NULL,
       y = NULL,
       title = "SEXY1x3 - 2026 annual rye planting map",
       caption = paste("Created by Gina\nLast updated:", date()),
       fill = NULL)
