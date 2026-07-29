#--created 28 july 2028
#--updated
#--purpose: read in lab's water nitrate data

library(tidyverse)
library(readxl)


rm(list = ls())


# function ----------------------------------------------------------------

my_names <- c("lab_id", "analyzer_id", "delete", "nitraten_mgl")


ReadSWNitrateFiles <- function(f = filename){

  d <- read_excel(f,
                  skip = 47, col_names = F)

  names(d) <- my_names

  d2 <-
    d |>
    mutate(
      filename = f,
      across(everything(), as.character))

  return(d2)

}


# 1. use the function on the list of files -----------------------------------

# Path to folder of first dump
folder_path <- "data-raw/sexy1/sw_nitrate/sexy1-raw/"

# Get all csv files in the folder
files <- list.files(
  path = folder_path,
  pattern = "\\.xlsx$",
  full.names = TRUE
)

#--make a giant dataframe (inefficient, but it's fine)
a1 <- map_dfr(files, ReadSWNitrateFiles)


# 2. get rid of unneeded cols ---------------------------------------------

a2 <-
  a1 |>
  select(-delete)


# 3. write intermediate file ----------------------------------------------

a2 |>
  write_csv("data-raw/sexy1/sw_nitrate/tidy_raw-data.csv")
