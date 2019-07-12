# Plot of the sites we are using in our study - Figure 1

library(tidyverse)
library(leaflet)
library(mapview)



dataIn <- 'data-raw/fluxnet-dbf-mod-v2/Fluxnet-DBF-MOD-V2-MOD09GA-006-results.csv'

siteData <- read_csv(dataIn)

specs <- siteData %>% group_by(Category) %>%
  distinct(ID,.keep_all=TRUE) %>%
  select(1:4)


labs(y = expression ("Acceleration in"~m/s^2))
expression("Temperature " ( degree~C))
# Make a map of the different sites and their representation, we also need to get that summary table built in
mapWorld <- borders("world", colour="gray50", fill="gray50") # create a layer of borders
mp <- ggplot() +   mapWorld +
  geom_point(data=specs,mapping=aes(x=Longitude, y=Latitude) ,color="red", size=2) + coord_quickmap() + labs(x=expression("Longitude " ( degree)), y=expression("Latitude " ( degree))) +xlim(c(-180,180)) +
  theme_bw()

ggsave(filename="manuscript-figures/siteMap.png",plot=mp,dpi=600)


