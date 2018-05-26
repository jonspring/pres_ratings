
# dot plot for each pres --------------------------------------------------
ggplot(greatness, aes(name, rating, color = category)) +
  geom_point() +
  coord_flip()


greatness_ideology <-
  greatness %>%
  spread(category, rating) %>%
  mutate(rep_less_dem = republican - democrat,
         conserv_less_lib = conservative - liberal,
         name_mod = fct_reorder(name, moderate),
         name_indep = fct_reorder(name, independent))

# Dot plot sorted by moderate rating
greatness_ideology %>%
  select(-rep_less_dem, -conserv_less_lib) %>%
  gather(category, rating, conservative:republican) %>%
ggplot(aes(name_mod, rating, color = category)) +
  geom_point() +
  coord_flip()

ggplot(greatness_ideology, aes(rep_less_dem, conserv_less_lib, label = name)) +
  annotate("rect", xmin = -10, xmax = 10,
           ymin = -10, ymax = 10, alpha = 0.1) +
  geom_abline(slope = 1, lty="dotted", color = "gray50") +
  geom_point() +
  ggrepel::geom_text_repel(size = 2) +
  coord_equal() +
  labs(title = "Ideological gap in ratings",
       subtitle = "Most presidents are judged similarly +/-10% across the aisle",
       x = "Preference by Republicans",
       y = "Preference by Conservatives")


ggplot(greatness_ideology, aes(republican, democrat, label = name)) +
  geom_abline(slope = 1, lty="dotted", color = "gray50") +
  geom_point() +
  ggrepel::geom_text_repel(size = 2) +
  coord_equal(xlim = c(0,100), ylim = c(0,100), expand = c(0,0)) +
  labs(title = "There is broad consensus between GOP and Dem raters",
       x = "Republican rating",
       y = "Democrat rating")


ggplot(greatness_ideology, aes(independent, -rep_less_dem, label = name)) +
  geom_point() +
  ggrepel::geom_text_repel(size = 2) +
  coord_equal() +
  labs(title = "There is broad consensus between GOP and Dem raters",
       x = "Independent rating",
       y = "Democrat preference")



# Most divisive? -------------
greatness_stats <-
  greatness %>%
  group_by(name) %>%
  summarise(min = min(rating),
            mean = mean(rating),
            max = max(rating),
            sd = sd(rating)) %>%
  left_join(greatness_ideology)

ggplot(greatness_stats %>% 
         select(name, number, mean, sd) %>%
         gather(stat,value, mean:sd), 
       aes(number, value, label = name)) +
  geom_point() +
  geom_smooth() +
  facet_grid(stat~., scales = "free_y") +
  ggrepel::geom_text_repel(size = 2, ncol = 1) +
  labs(title = "Opinions are more polarized about the last 20 presidents")

# Not really working, but intention is to show wider opinion range as less certain
ggplot(greatness_stats %>% 
         select(name, number, mean, sd),
       aes(number, mean, label = name, alpha = 1/sd)) +
  geom_point() +
  geom_errorbar(aes(ymin = mean - sd, ymax = mean+sd))+
  ggrepel::geom_text_repel(size = 2, alpha = 0.8) +
  labs(title = "Opinions are more polarized about the last 20 presidents")

