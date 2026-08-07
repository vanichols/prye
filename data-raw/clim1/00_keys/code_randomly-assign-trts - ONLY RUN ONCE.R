#--make things in R so I don't mess up in Excel

rm(list = ls())

library(tidyverse)
library(readxl)

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))



# 1. make plot map --------------------------------------------------------

#--get treatments

d <- read_excel("../../SEXY1 - Field22/03_field sampling support docs/SEXY1 - grain sample labels2.xlsx")

d1 <- 
  d %>% 
  select(trt) %>% 
  distinct() %>% 
  mutate(trt_nu = 1:12)

#--randomly assign each treatment to a block - only do this once
b1 <- sample(x = c(1:12), size = 12, replace = F)
b2 <- sample(x = c(1:12), size = 12, replace = F)
b3 <- sample(x = c(1:12), size = 12, replace = F)
b4 <- sample(x = c(1:12), size = 12, replace = F)

d2 <- 
  tibble(b1 = b1, 
         b2 = b2, 
         b3 = b3, 
         b4 = b4) %>% 
  pivot_longer(b1:b4) %>% 
  rename(trt_nu = value) %>% 
  left_join(d1) %>% 
  arrange(name) %>% 
  group_by(name) %>% 
  mutate(n = 1:n(),
         xx = as.numeric(str_sub(name, 2, 2)),
         plot = xx * 100 + n)

d3 <- 
  d2 %>% 
  select(block=name, plot, trt)

d3 %>% 
  write.table("../plot-key.csv", sep = ";", row.names = F)

d3 %>% 
  ggplot(aes(plot, block)) +
  geom_tile(aes(fill = trt), color = "black") +
  geom_label(aes(label = trt)) +
  facet_wrap(~block, scales = "free", ncol = 4)
