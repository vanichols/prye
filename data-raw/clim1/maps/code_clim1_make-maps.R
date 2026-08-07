# created: 7 aug 2026
# purpose: make a planting map for each season to give to anders

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
        axis.ticks.x = element_blank(),
        axis.text.x = element_text(angle = 90, hjust = 1,
                                   vjust = 0.5,
                                   margin = margin(t = 0)))



#--note the maps will change as we assign treatments to the treatment numbers

# 1. fall 2026 map --------------------------------------------------------

#--get treatments and build structure
d1 <-
  read_csv("inst/extdata/clim1_plotkey.csv") |>
  mutate(block = str_replace_all(block, "b", "Block "))


#--make separate block maps
blocks <- unique(d1$block)

for (b in 1:length(blocks)) {


  df_sub <- subset(d1, block == blocks[b])

  p <-
    df_sub %>%
    mutate(h = 1,
           trt_assigned = ifelse(is.na(trt_name), "no", "yes"),
           fall_planting = ifelse(grepl("26s", trt_name), "no", "yes"),
           fall_planting = ifelse(trt_name == "PRACTICE", "no", fall_planting),
           plot2 = as.factor(plot),
           plot3 = fct_inorder(plot2)) %>%
    ggplot(aes(plot3, h)) +
    geom_col(aes(fill = trt_assigned),
             color = "black",
             position = position_dodge(), show.legend = F) +
    geom_label(aes(label = trt_name, color = fall_planting),
               angle = 90, y = 0.5, show.legend = F,
               size = 8) +
    scale_fill_manual(values = c("no" = "gray", "yes" = "white")) +
    scale_color_manual(values = c("no" = "gray", "yes" = "green4")) +
    facet_wrap(~block, scales = "free", ncol = 2) +
    scale_y_continuous(expand = expansion(mult = c(0, 0))) +
    labs(x = NULL,
         y = NULL,
         title = "CLIM1 - 26/27 season",
         caption = paste("Created by Gina\nLast updated:", date())) +
    theme(axis.text.y = element_blank(),
          strip.text = element_text(size = rel(1.2),
                                    face = "italic"),
          panel.grid.major.x = element_blank(),
          axis.ticks.x = element_blank(),
          axis.text.x = element_text(angle = 90, hjust = 1,
                                     vjust = 0.5,
                                     margin = margin(t = 0)))

  ggsave(
    filename = paste0("data-raw/clim1/maps/00_plot-treatments-map_", blocks[b], ".pdf"),
    plot = p,
    width = 15,
    height = 5
  )
}
