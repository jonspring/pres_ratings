
# dot plot for each pres --------------------------------------------------
ggplot(greatness, aes(name, rating, color = category)) +
  geom_point() +
  coord_flip()


greatness_ideology <-
  greatness %>%
  spread(category, rating) %>%
  mutate(rep_less_dem = republican - democrat,
         conserv_less_lib = conservative - liberal)


ggplot(greatness_ideology, aes(rep_less_dem, conserv_less_lib, label = name)) +
  annotate("rect", xmin = -10, xmax = 10,
           ymin = -10, ymax = 10, alpha = 0.1) +
  geom_point() +
  ggrepel::geom_text_repel(size = 2) +
  labs(title = "Ideological gap in ratings",
       subtitle = "Most presidents are judged similarly +/-10% by different parties",
       x = "Preference by Republicans",
       y = "Preference by Conservatives")


ggplot(greatness_ideology, aes(republican, democrat, label = name)) +
  geom_point() +
  ggrepel::geom_text_repel(size = 2) +
  labs(title = "There is broad consensus between GOP and Dem raters",
       x = "Republican rating",
       y = "Democrat rating")


ggplot(greatness_ideology, aes(independent, rep_less_dem, label = name)) +
  geom_point() +
  ggrepel::geom_text_repel(size = 2) +
  coord_equal() +
  labs(title = "There is broad consensus between GOP and Dem raters",
       x = "Independent rating",
       y = "Republican preference")
