#pumpkins wk43

#Getting the data ----
pumpkins <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-10-19/pumpkins.csv')

#Loading packages ----
library(tidyverse)
library(usmap)
library(RColorBrewer)
library(grid)
library(gridExtra)
library(extrafont)

#Data wrangling ----
pumpkins <- pumpkins %>% 
  filter(!(str_detect(country, "Entries"))) %>%
  mutate(weight_lbs = as.numeric(str_remove(weight_lbs, ","))) %>%
  separate(id, into = c("year", "type"), sep = "-")



state_pumpkins_total <- pumpkins %>% 
  filter(country == "United States") %>%
  count(state_prov) %>%
  rename(state = state_prov) %>%
  arrange(desc(n))


wt <- pumpkins %>% 
  filter(country == "United States") %>%
  group_by(state_prov) %>%
  summarize(max = max(weight_lbs)) %>%
  arrange(desc(max))

top_states <- filter(wt, max > 2000) %>%
  select(state_prov) %>%
  unlist()

state_pumpkins_wt <- pumpkins %>% 
  filter(country == "United States") %>%
  filter(state_prov %in% top_states) %>%
  mutate(state_prov = factor(state_prov, levels = top_states))



#Data visualization ----

#US map, colored accordingly to the amount of pumpking 

p1 <- plot_usmap(regions = "states", data = state_pumpkins_total, 
           values = "n", labels = TRUE) +
  scale_fill_distiller(palette = "Oranges", direction = 1, name = "Number of entries") +
  labs(title = "US map colored according to the number of entries into the GPC competitions 
from 2013 to 2021",
       subtitle = "Wisconsin had the largest number of entries, followed by California and Ohio") +
  theme_void() +
  theme(text = element_text(family = "Georgia"),
        plot.title = element_text(size = 20, face = "bold"),
        plot.subtitle = element_text(size = 18),
        legend.title = element_text(size = 16),
        legend.text = element_text(size = 16))

# Distribution of pumpking weight per state

#Which was the heaviest pumpkin?
state_pumpkins_wt %>%
  filter(weight_lbs == max(state_pumpkins_wt$weight_lbs))

label <- left_join(wt, state_pumpkins_total, by = c("state_prov" = "state")) %>%
  filter(max > 2000)

my_colors <- rev(colorRampPalette(brewer.pal(9, "Oranges"))(30))

p2 <- ggplot(state_pumpkins_wt, aes(x = fct_rev(state_prov), y = weight_lbs, 
                                    fill = state_prov)) +
  geom_violin() +
  coord_flip() +
  scale_fill_manual(values = my_colors) +
  labs(title = "Distribution of pumpkin weights registered from 2013 to 2021, 
for the 30 states whith the heaviest pumpkins",
       subtitle = "The heaviest pumpking in the US was grown in New Hampshire, 
in 2018, by grower Steve Geddes. It weighted 2528 lbs!") +
  geom_text (data = label, aes(y = 2700, label = paste("n = ", n)), size = 5) +
  ylim(0,3000) +
  labs(x = element_blank(), y = "Pumpkin weight (lbs)") +
  theme_bw() + theme(text = element_text(family = "Georgia"),
                     plot.title = element_text(size = 20, face = "bold"),
                     plot.subtitle = element_text(size = 18),
                     axis.title = element_text(size = 16),
                     axis.text = element_text(size = 14, face = "bold", color = "black"),
                     legend.position = "none")



#annotations

title <- textGrob("IT'S PUMPKIN SEASON!", 
                  gp = gpar(fontsize = 40, fontface = 'bold', 
                            fontfamily = "Georgia", col = "chocolate"))

subtitle <- textGrob("The Great Pumpkin Commonwealth's (GPC) mission cultivates the hobby of growing giant pumpkins throughout the world by establishing standards
and regulations that ensure quality of fruit, fairness of competition, recognition of achievement, fellowship and education for all participating growers and
weigh-off sites. Several US states have GPC growing sites. Which state had more participation entries and which produced the heaviest pumpkin?", 
                     gp = gpar(fontsize = 25,
                               fontfamily = "Georgia"),
                     just = "left", x = unit(0, "npc"))

caption <- textGrob("Data from BigPumpkins.com | Amanda Fanelli for TidyTuesday Wk 43", 
                   gp = gpar(fontsize = 16,
                             fontfamily = "Georgia"),
                   just = "right", x = unit(1, "npc"))

png(filename="tidytuesday/wk43_pumpkins/pumpkins.png", width = 62, height = 53, units = "cm", res = 600)
grid.arrange(title,
             subtitle,
             arrangeGrob(p1,p2, ncol = 2),
             caption,
             nrow = 4,
             heights = c(5,5,38,5))
dev.off()


