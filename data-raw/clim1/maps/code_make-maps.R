#--make things in R so I don't mess up in Excel

rm(list = ls())

library(tidyverse)
library(scales)
library(SEXYrye)
library(ggpattern)

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

theme_set(theme_minimal())

th1 <- 
  theme(axis.text.y = element_blank(),
      strip.text = element_text(size = rel(1.2),
                                face = "italic"),
      panel.grid.major.x = element_blank(),
      axis.text.x = element_text(angle = 90, vjust = 0.5))


# 1. make plot map --------------------------------------------------------

#--get treatments
d1 <- 
  read.table("../plot-key.csv", sep = ";", header = T) %>% 
  as_tibble() %>% 
  mutate(plot = as.factor(plot), 
         block = str_replace_all(block, "b", "Block "),
         plot_half1 = "A",
         plot_half2 = "B") %>% 
  pivot_longer(plot_half1:plot_half2) %>% 
  select(-name) %>% 
  rename(plot_half = value)
  

d1 %>% 
  mutate(h = 1) %>% 
  ggplot(aes(plot, h)) +
  geom_col(fill = "white", color = "black", position = position_dodge()) +
  geom_label(aes(label = trt), color = "red4", angle = 90, y = 0.5) +
  scale_y_discrete(expand = c(0.01, 0.01)) +
  facet_wrap(~block, scales = "free", ncol = 4) +
  th1 +
  labs(x = NULL,
       y = NULL,
       title = "SEXY2 - 25/26 season",
       caption = paste("Created by Gina\nLast updated:", date()))

ggsave("../01_maps/00_plot-treatments-map.pdf", 
       width = 14, height = 3)



# 2. make planting maps ---------------------------------------------------

d2 <- 
  d1 %>% 
  left_join(sexy1_trtkey  %>% 
              rename(trt = trt_id)) %>% 
  mutate(cropcat = case_when(
    croptrt_id == "aprows" ~ "mix-rows",
    TRUE ~ cropcat
  )) %>% 
  mutate(plot = paste0(plot, plot_half),
         plot = as.factor(plot))


#--annual planting map
d2 %>% 
  mutate(h = 1) %>% 
  mutate(fill_color = ifelse(cropcat %in% c("ann", "mix-rows"), "color", "none"),
         fill_pattern = ifelse(cropcat == "mix-rows", "pat1", "none")) %>% 
  ggplot(aes(plot, h)) +
  geom_col_pattern(aes(fill = fill_color, pattern = fill_pattern), 
                   color = "black", show.legend = F, 
                   pattern_angle = 80) +
  geom_label(data = . %>% filter(cropcat %in% c("ann", "mix-rows")),
             aes(label = trt), y = 0.5, color = "red4", angle = 90) +
  scale_y_continuous(limits = c(0, 1), expand = c(0.01, 0.01)) +
  scale_fill_manual(values = c("color" = "skyblue", "none" = "white")) +
  scale_pattern_manual(values = c("pat1" = "stripe", "none" = "none")) +
  facet_wrap(~block, scales = "free", ncol = 4) +
  th1 +
  labs(x = NULL,
       y = NULL,
       title = "SEXY2 - 2025 annual rye planting map",
       caption = paste("Created by Gina\nLast updated:", date()),
       fill = NULL)

ggsave("../01_maps/01_annualrye-planting-map.pdf", 
       width = 16, height = 3)

#--perennial planting map
d2 %>% 
  mutate(h = 1) %>% 
  mutate(fill_color = ifelse(cropcat %in% c("perenn", "mix-rows"), "color", "none"),
         fill_pattern = ifelse(cropcat == "mix-rows", "pat1", "none")) %>% 
  ggplot(aes(plot, h)) +
  geom_col_pattern(aes(fill = fill_color, pattern = fill_pattern), 
                   color = "black", show.legend = F, 
                   pattern_angle = 80) +
  geom_label(data = . %>% filter(cropcat %in% c("perenn", "mix-rows")),
             aes(label = trt), y = 0.5, color = "red4", angle = 90) +
  scale_y_continuous(limits = c(0, 1), expand = c(0.01, 0.01)) +
  scale_fill_manual(values = c("color" = "mediumpurple3", "none" = "white")) +
  scale_pattern_manual(values = c("pat1" = "stripe", "none" = "none")) +
  facet_wrap(~block, scales = "free", ncol = 4) +
  th1 +
  labs(x = NULL,
       y = NULL,
       title = "SEXY2 - 2025 perennial rye planting map",
       caption = paste("Created by Gina\nLast updated:", date()),
       fill = NULL)

ggsave("../01_maps/01_prye-planting-map.pdf", 
       width = 16, height = 3)

#--mixture planting map
d2 %>% 
  mutate(h = 1) %>% 
  mutate(fill_color = ifelse(cropcat %in% c("mix"), "color", "none"),
         fill_pattern = ifelse(cropcat == "mix", "none", "none")) %>% 
  ggplot(aes(plot, h)) +
  geom_col_pattern(aes(fill = fill_color, pattern = fill_pattern), 
                   color = "black", show.legend = F, 
                   pattern_angle = 80) +
  geom_label(data = . %>% filter(cropcat %in% c("mix")),
             aes(label = trt), y = 0.5, color = "red4", angle = 90) +
  scale_y_continuous(limits = c(0, 1), expand = c(0.01, 0.01)) +
  scale_fill_manual(values = c("color" = "palegreen4", "none" = "white")) +
  scale_pattern_manual(values = c("pat1" = "none", "none" = "none")) +
  facet_wrap(~block, scales = "free", ncol = 4) +
  th1 +
  labs(x = NULL,
       y = NULL,
       title = "SEXY2 - 2025 mixture planting map",
       caption = paste("Created by Gina\nLast updated:", date()),
       fill = NULL)

ggsave("../01_maps/01_mixture-planting-map.pdf", 
       width = 16, height = 3)
