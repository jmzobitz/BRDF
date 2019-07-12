# Now we can start processing figures - yay!

# Figure 2: Time series of used data
data_points <- fluxnet %>%
  group_by(site) %>%
  summarize(tot=n()) %>%
  rbind(c("","Total no. days")) %>%
  mutate(site = fct_reorder(site, desc(site)))




data_plot <- fluxnet %>%
  mutate(site = fct_reorder(site, desc(site))) %>%
  ggplot() +
  geom_text(data=data_points,aes(x=380,y=site,label=tot),size=6,hjust='right',nudge_x = 6) +
  geom_point(aes(x=time,y=site),size=3,shape=15) +
  labs(y="Site",x="Day of year") +
  xlim(0,385)+
  #theme(strip.text.x = element_text(size=14),
  #      strip.text.y = element_text(size=14),
  #      strip.background = element_rect(colour="white", fill="white")) +
  scale_x_continuous(breaks = c(1,90,180,270,365)) +
  theme_bw() +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(), axis.line = element_line(colour = "black")) +
theme(axis.text = element_text(size=18),
      axis.title=element_text(size=22))

fileName <- paste0('manuscript-figures/dataPlot.png')
ggsave(fileName,plot=data_plot,width=11,height=10,dpi=600)
