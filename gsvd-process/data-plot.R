# Now we can start processing figures - yay!

# Figure 2: Time series of used data
data_points <- fluxnet %>%
  group_by(site) %>%
  summarize(tot=n()) %>%
  mutate(site = fct_reorder(site, desc(site)))


data_plot <- fluxnet %>%
  mutate(site = fct_reorder(site, desc(site))) %>%
  ggplot() +
  geom_text(data=data_points,aes(x=380,y=site,label=tot),size=6) +
  geom_point(aes(x=time,y=site),size=3,shape=15) +
  labs(y="Site",x="Day of Year") +
  xlim(0,385)+
  theme(axis.text = element_text(size=14),
        axis.title=element_text(size=28),
        title=element_text(size=26),
        legend.text=element_text(size=12),
        legend.title=element_text(size=16)) +
  theme(legend.position="bottom") +
  theme(strip.text.x = element_text(size=14),
        strip.text.y = element_text(size=14)) +
  scale_x_continuous(breaks = c(1,90,180,270,365))


fileName <- paste0('manuscript-figures/dataPlot.png')
ggsave(fileName,plot=data_plot,width=11,height=10)
