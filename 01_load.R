library(tidyverse)

greatness_raw <- readxl::read_excel("data/Greatness.xlsx", skip = 199, n_max = 50)

greatness <- 
  greatness_raw %>%
  janitor::clean_names() %>%
  filter(!is.na(name), name != "6") %>%
  gather(category, rating, -name) %>%
  mutate(rating = rating %>% as.numeric())

