# Figure 5: albedo plot over time


# Are any of these negative?
albedo_list %>% bind_rows(.id="site") %>%
  group_by(site,band) %>%
  filter(value<0 ) %>%
  summarize(tot=n(),mean_val=mean(value),std=sd(value))




site_read = c("AU-Lox","IT-CA1","ZM-Mon","JP-MBF","DE-Hai","US-Wi3")
band_read = c("band1","band2")

# filter out our data and the mcd4s
mcd43A3_data <- mcd43A3 %>%
  filter(site %in% site_read & type =="white-sky" & band %in% band_read ) %>%
  mutate(method='MCD43A3')

gsvd_data <- albedo_list %>% bind_rows(.id="site") %>%
  mutate(value=pmax(value,0),
         value=pmin(value,1)) %>%   # Set values between 0 and 1 for the albedo
  filter(site %in% site_read & type =="white-sky" & band %in% band_read ) %>%
  mutate(method='GSVD')

big_data <- rbind(mcd43A3_data,gsvd_data)

prepender_b <- function(string, prefix = "Band ") {
  string_new=string %>% str_sub(-1)
  paste0(prefix,string_new)

}


albedoPlot   <- big_data %>%
  mutate(site = fct_relevel(site, site_read)) %>%
  ggplot(aes(x=time,y=value,color=method,shape=method)) +
  geom_point(data = subset(big_data, method == "GSVD")) +
  geom_point(data = subset(big_data, method == "MCD43A3")) +
  facet_grid(site~band,labeller=labeller(band=prepender_b)) +
  labs(x="Day of year", y="White sky albedo",color="Method",shape="Method") +
  theme_bw() +
  theme(axis.text = element_text(size=14),
        axis.title=element_text(size=24),
        title=element_text(size=26),
        legend.text=element_text(size=12),
        legend.title=element_text(size=16)) +
  theme(legend.position="bottom") +
  theme(strip.text.x = element_text(size=12),
        strip.text.y = element_text(size=12),
        strip.background = element_rect(colour="white", fill="white")) +
  scale_x_continuous(breaks = c(1,90,180,270,365)) +
  theme( panel.grid.major = element_blank(),
         panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"))





fileName <- paste0('manuscript-figures/albedoPlot.png')
ggsave(fileName,plot=albedoPlot,width=7,height=12,dpi=600)

