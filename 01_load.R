library(tidyverse)

greatness_raw <- readxl::read_excel("data/Greatness.xlsx", skip = 199, n_max = 50)

greatness <- 
  greatness_raw %>%
  janitor::clean_names() %>%
  filter(!is.na(name), name != "6") %>%
  mutate(number = row_number()) %>%
  mutate(number = if_else(number >= 24, as.integer(number+1), number)) %>% ### Darn you Grover Cleveland!
  mutate(name = fct_reorder(name, number)) %>%
  gather(category, rating, republican:moderate) %>%
  mutate(rating = rating %>% as.numeric())

