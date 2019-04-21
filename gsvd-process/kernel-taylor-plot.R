##  Taylor Plot for modis kernel weights - Figure 6
##########


# Function to rename the kernel values from 0 1 2 to the abbreviation

prepender_k <- function(string){
  name <- string %>% str_replace_all("0","f[iso]") %>%
    str_replace_all("1","f[vol]") %>%
    str_replace_all("2","f[geo]")


  return(name)

}


# clean up the modis data and our GSVD data, joining them together
mcd43A1_data <- modisBRDF %>%
  mutate(method='MCD43A1',kernel=prepender_k(kernel)) %>%
  rename(MCD43A1 = value) %>%
  select(-method)

gsvd_data <- solution_list %>% bind_rows(.id="site") %>%
  mutate(method='GSVD',kernel=prepender_k(kernel)) %>%
  rename(GSVD=value) %>%
  select(-method)


kernel_data <- mcd43A1_data %>% left_join(gsvd_data,by=c("site","time","band","kernel"))

# Allows us to add a heading to our facets
prepender_b <- function(string, prefix = "Band ") {
  string_new=string %>% str_sub(-1)
  paste0(prefix,string_new)

}


# Determine which of the sites have lambda that converged
lambda_values <- lambda_list %>% bind_rows(.id="site")

# Determine how many data points we have in our datasets, making it into a categorical variable
data_points <- fluxnet %>%
  group_by(site) %>%
  summarize(tot=n()) %>%
  mutate(bin = cut_interval(tot,length=40))


# normalize the results, see Taylor 2001
# E = E'/sigma_meas
# sigma_model = sigma_model/sigma_meas
# sigma_meas = 1

kernel_rsq <- kernel_data %>%
  group_by(site,band,kernel) %>%
  summarize(sd_meas=1,
            sd_gsvd=sd(GSVD)/sd(MCD43A1),
            r=cor(MCD43A1,GSVD),
            centered_rms=sd((MCD43A1-mean(MCD43A1))-((GSVD-mean(GSVD))))/sd(MCD43A1)
  ) %>%
  mutate(x_coord = sd_gsvd*r, y_coord = sd_gsvd*sin(acos(r))) %>%
  left_join(data_points,by=c("site")) %>%
  left_join(lambda_values,by=c("site","band")) %>%
  filter(converged) %>%  # only look at sites than have converged
  mutate(kernel = fct_relevel(kernel, c("f[iso]","f[vol]","f[geo]"))) # Reorder the factors so they makes sense in how they are read (rather than alphabetical)



t_plot <- taylor_plot()

curr_plot <- t_plot +
  geom_point(data=kernel_rsq,aes(x=x_coord,y=y_coord)) +
  facet_grid(kernel~band,labeller=labeller(kernel=label_parsed,band=prepender_b)) +
  labs(x="",y=expression(sigma[GSVD])) +
  theme_bw() +
  theme(axis.text = element_text(size=14),
        axis.title=element_text(size=28),
        title=element_text(size=26),
        legend.text=element_text(size=12),
        legend.title=element_text(size=14)) +
  theme(strip.text.x = element_text(size=12),
        strip.text.y = element_text(size=12),
        strip.background = element_rect(colour="white", fill="white"))




fileName <- paste0('manuscript-figures/kernelTaylor.png')
ggsave(fileName,plot=curr_plot,width=18,height=7)




