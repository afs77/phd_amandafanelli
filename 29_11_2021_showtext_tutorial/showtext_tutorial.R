#Amanda Fanelli para o instagram (@phd_amandafanelli)
#Tutorial showtext

#Instalar o pacote showtext 
install.packages("showtext")

#Anexar os pacotes
library(showtext)
library(tidyverse)
library(lubridate)
library(colorspace)

#Adicionar uma fonte do google fonts
font_add_google("Gochi hand", "gochi")
font_add_google("Bellota", "bellota")


#Utilizar o showtext para render o texto
showtext_auto()

#Importar os dados do projeto tidytuesday
library(tidytuesdayR)
tuesdata <- tidytuesdayR::tt_load('2021-08-24')
lemur_data <- tuesdata$lemur_data
taxonomy <- tuesdata$taxonomy

#Limpa os dados
lemurs <- left_join(lemur_data, taxonomy, by = "taxon")

lemurs <- lemurs %>%
  select(taxon, dlc_id, hybrid, sex, name, weight_g, 
         weight_date, latin_name, common_name) %>%
  mutate(year = year(weight_date))

lemurs_yr <- lemurs %>%
  filter(year == 2019) %>%
  filter(!is.na(common_name)) 

count_taxon <- lemurs_yr %>%
  count(taxon) %>%
  filter(n > 11 & n < 90)

lemurs_wt <- lemurs_yr %>%
  filter(taxon %in% count_taxon$taxon)

#Grafico usando diferentes fontes. 

my_colors <- c("darkgreen", "darkolivegreen", 
               "darkolivegreen3", "darkseagreen", 
               "darkslategrey", "chartreuse4")

p <- ggplot(lemurs_wt, aes(y = common_name, 
                           x = weight_g, fill = common_name, 
                           color = after_scale(darken(fill, 0.6))))+ 
  geom_boxplot(outlier.shape = NA,
               size = 0.8, alpha = 0.8) +
  geom_jitter() +
  scale_color_manual(values = my_colors) +
  scale_fill_manual(values = my_colors) +
  labs(y = NULL, x = "Weight (g)",
       title = "What's the weight of different species of lemur?",
       subtitle = "Weights obtained in 2019, for animals that were born in institutions around the world",
       caption = "Data from Duke Lemur Center. Zehr et al., 2014") +
  theme_classic() + 
  theme(legend.position = "none",
        plot.title = element_text(family = "gochi", size = 44),
        plot.subtitle = element_text(family = "bellota", size = 28),
        plot.caption = element_text(family = "bellota", size = 28),
        axis.title = element_text(family = "gochi", size = 28),
        axis.text = element_text(family = "gochi", 
                                 color = "black", size = 28))

ggsave("lemurs.png", width = 7, height = 5, units = "in")
