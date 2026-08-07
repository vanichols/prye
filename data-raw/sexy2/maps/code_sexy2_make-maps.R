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
      axis.text.x = element_text(angle = 90, vjust = 0.5),
      plot.title = element_text(face = "bold"))



# 1. sexy2 25/26 --------------------------------------------------------

#--get treatments and build structure
d1 <-
  read_csv("inst/extdata/sexy2_plotkey.csv") |>
  filter(sea_name == "25/26") |>
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
  facet_wrap(~block, scales = "free", ncol = 4) +
  th1 +
  labs(x = NULL,
       y = NULL,
       title = "SEXY2x2 - 25/26 season",
       caption = paste("Created by Gina\nLast updated:", date()))

ggsave("data-raw/sexy2/maps/sexy2x2_plot-treatments-map.pdf",
       width = 15, height = 5)




# 2. sexy2 26/27 --------------------------------------------------------

#--get treatments and build structure
d2 <-
  read_csv("inst/extdata/sexy2_plotkey.csv") |>
  filter(sea_name == "26/27") |>
  mutate(plot = as.character(plot),
         block = str_replace_all(block, "B", "Block "),
         plot_half1 = "A",
         plot_half2 = "B") %>%
  pivot_longer(plot_half1:plot_half2) %>%
  select(-name) %>%
  rename(plot_half = value)


d2 %>%
  mutate(h = 1) %>%
  ggplot(aes(plot, h)) +
  geom_col(fill = "white", color = "black", position = position_dodge()) +
  geom_label(aes(label = trt_name), color = "red4", angle = 90, y = 0.5) +
  scale_y_discrete(expand = c(0.01, 0.01)) +
  facet_wrap(~block, scales = "free", ncol = 4) +
  th1 +
  labs(x = NULL,
       y = NULL,
       title = "SEXY2x3 - 26/27 season",
       caption = paste("Created by Gina\nLast updated:", date()))

ggsave("data-raw/sexy2/maps/sexy2x3_plot-treatments-map.pdf",
       width = 15, height = 5)


#--get treatments and build structure
d2 <-
  read_csv("inst/extdata/sexy2_plotkey.csv") |>
  filter(sea_name == "26/27") |>
  mutate(plot = as.character(plot),
         block = str_replace_all(block, "B", "Block "),
         plot_half1 = "A",
         plot_half2 = "B") %>%
  pivot_longer(plot_half1:plot_half2) %>%
  select(-name) %>%
  rename(plot_half = value)

#--planting in fall 2026 map
d2 |>
  mutate(fill_color = ifelse(trt_name %in% c("p", "acc", "pcc", "a"), "planting", "do nothing")) |>
  mutate(h = 1) %>%
  ggplot(aes(plot, h)) +
  geom_col(aes(fill = fill_color), color = "black", position = position_dodge()) +
  geom_label(aes(label = trt_name), color = "red4", angle = 90, y = 0.5) +
  scale_y_discrete(expand = c(0.01, 0.01)) +
  scale_fill_manual(values = c("planting" = "green4", "do nothing" = "white")) +
  facet_wrap(~block, scales = "free", ncol = 4) +
  th1 +
  labs(x = NULL,
       y = NULL,
       title = "SEXY2x3 - 26/27 season - fall 2026 planting",
       fill = "Fall 2026:",
       caption = paste("Created by Gina\nLast updated:", date())) +
  theme(legend.position = "top")

ggsave("data-raw/sexy2/maps/sexy2x3_plot-treatments-map-fall 2026 planting.pdf",
       width = 15, height = 5)

