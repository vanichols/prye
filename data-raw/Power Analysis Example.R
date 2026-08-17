# Power Analysis with powerutilities

# The last three here are required, tidyverse is just handy
library(tidyverse)
library(glmmTMB)
library(emmeans)
library(powerutilities)

# fake data set should include correct number of treatments, reps, blocks, etc.
# reponse variable should be set to expected mean for each treatment combination,
# sometimes this is easier to do in Excel
sim = expand.grid(trt = c('Per', 'Per-CC'),
                  nitro = c('Yes', 'No'),
                  blk = factor(1:4)) |> 
  mutate(biomass = case_when(trt == 'Per' ~ 300, .default = 480), 
         biomass = case_when(nitro == 'Yes' ~ biomass*1.5, .default = biomass))

# Check everything looks good
sim

# Here we specify the model. Random effects need to match design, 
# which re_terms and disp are supplied as standard deviations (see vignette
# if RE are complicated, such as random slopes, spatial correlation, etc.)
mod = set_glmm(biomass ~ trt*nitro + (1|blk) + (1|blk:trt) + (1|blk:nitro),
               data = sim, REML = TRUE, 
               re_terms = c(45, 45, 45), disp = c(100))

# Power calculations for F-tests. Power is the probability of getting p < 0.05
# given everything that was plugged into the model, and 0.80 is conventional
# standard for "adaquite power".
power_ftest(mod, ddf = 'kenward-roger')

# Typically we then want to assess the precision of our estimates (via SE or Confidence Interval) 
# and/or assess power of contrasts or pairwise comparisions, which requires 
# creating emmeans object.
(emm = emmeans(mod, ~ nitro)) # We can already see/assess precision here

# Create list of contrasts to assess power
n_contr = list('N - No N' = c(1, -1))

# In addition to power, we get Type S (sign) and Type M (magnitude) 
# error rates. We want Type S to be close to zero, and Type M to be close to 1
power_contrast(emm, n_contr, ddf = 'kenward-roger')

# Here we re-run the power analysis above assuming a different design (note that
# we can use the same data set, we just modify the random effects strucuter in the
# model from that of a split-block to that of a split-plot)
mod2 = set_glmm(biomass ~ trt*nitro + (1|blk) + (1|blk:trt),
               data = sim, REML = TRUE, 
               re_terms = c(45, 45), disp = c(100))


power_ftest(mod2, ddf = 'kenward-roger')

(emm2 = emmeans(mod2, ~ nitro))
power_contrast(emm2, n_contr, ddf = 'kenward-roger')
