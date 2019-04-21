##  Taylor Plot for modis albedo - Figure 7

### Prepare the data we have:

# filter out our data and the mcd4s
mcd43A3_data <- mcd43A3 %>%
  filter(type =="white-sky") %>%
  mutate(method='MCD43A3') %>%
  select(-method,-type) %>%
  rename(MCD43A3 = value)

gsvd_data <- albedo_list %>% bind_rows(.id="site") %>%
  filter(type =="white-sky") %>%
  mutate(method='GSVD') %>%
  select(-method,-type) %>%
  rename(GSVD=value)

albedo_data <- mcd43A3_data %>% left_join(gsvd_data,by=c("site","time","band"))





# If we want additional arcs, we will need to figure out where they intersect with each other from the origin - UGH!

# Helpful website: https://r4stats.com/2017/04/18/group-by-modeling-in-r-made-easy/

### We need to spread the data out
prepender_k <- function(string, prefix = "Kernel ") paste0(prefix,string)
prepender_b <- function(string, prefix = "Band ") {
  string_new=string %>% str_sub(-1)
  paste0(prefix,string_new)

}

lambda_values <- lambda_list %>% bind_rows(.id="site") %>%
  mutate(bin_lambda = cut_number(lambda,n=5))

data_points <- fluxnet %>%
  group_by(site) %>%
  summarize(tot=n()) %>%
  mutate(bin = cut_interval(tot,length=40))


# normalize the results, see Taylor 2001
# E = E'/sigma_meas
# sigma_model = sigma_model/sigma_meas
# sigma_meas = 1

albedo_rsq <- albedo_data %>%
  group_by(site,band) %>%
  summarize(sd_meas=1,
            sd_gsvd=sd(GSVD)/sd(MCD43A3),
            r=cor(MCD43A3,GSVD),
            centered_rms=sd((MCD43A3-mean(MCD43A3))-((GSVD-mean(GSVD))))/sd(MCD43A3)
  ) %>%
  mutate(x_coord = sd_gsvd*r, y_coord = sd_gsvd*sin(acos(r))) %>%
  left_join(data_points,by=c("site")) %>%
  left_join(lambda_values,by=c("site","band")) %>%
  filter(converged)


t_plot <- taylor_plot()

curr_plot <- t_plot +
  geom_point(data=albedo_rsq,aes(x=x_coord,y=y_coord)) +
  facet_grid(~band,labeller=labeller(band=prepender_b))+
   labs(x="",y=expression(sigma[GSVD])) +
  theme_bw()+
  theme(axis.text = element_text(size=14),
        axis.title=element_text(size=28),
        title=element_text(size=26),
        legend.text=element_text(size=12),
        legend.title=element_text(size=14)) +
  theme(strip.text.x = element_text(size=12),
        strip.text.y = element_text(size=12),
        strip.background = element_rect(colour="white", fill="white"))



fileName <- paste0('manuscript-figures/albedoTaylor.png')
ggsave(fileName,plot=curr_plot,width=18,height=3.5)

