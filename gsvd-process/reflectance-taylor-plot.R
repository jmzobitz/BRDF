##  Taylor Plot for modis reflectance - Figure 6
##########
library(BRDF)
# modisBRDF weights
# we are taking modisBRDF and the site lists - maybe left join by site and time, selecting out the kernel - arrgh, this will be a little tricky, but we should be ok.


mcd43_kernels <- fluxnet %>%
  rename("0"=K_Iso,
         "1"=K_RossThick,
         "2"=K_LiSparse) %>%
  select(1:5) %>%
  mutate(obs = 1:dim(fluxnet)[1]) %>%  # Add a unique identifier for each row
  gather(key=kernel,value=brdf_value,"0","1","2") %>%  # Now join
  inner_join(modisBRDF,by=c("site"="site","time"="time","kernel"="kernel")) %>%
  group_by(site,time,band,obs) %>%
  summarize(modeled_rho=sum(brdf_value*value)) %>%
  select(-obs)


measured_rho <- fluxnet %>%
  select(site,time,band1,band2,band3,band4,band5,band6,band7) %>%
  gather(key=band_name,value=measured_rho,band1,band2,band3,band4,band5,band6,band7)


taylor_mcd43 <-
  mcd43_kernels %>%
  inner_join(measured_rho,by=c("site","time","band"="band_name")) %>%
  group_by(site,band) %>%
  summarize(
    sd_meas=1,
    sd_gsvd = sd(modeled_rho)/sd(measured_rho),
    r = cor(modeled_rho,measured_rho),
    centered_rms = sd((measured_rho-mean(measured_rho))-((modeled_rho-mean(modeled_rho))))/sd(measured_rho),
    x_coord = sd_gsvd*r,
    y_coord = sd_gsvd*sin(acos(r))
  ) %>%
  mutate(method="MCD43A1") %>%
  ungroup()



# Pull up the data
site_list <- fluxnet %>% split(.$site)


# Compute the kernel matrices, as a list by site
data_list <-map(site_list,~kernel_matrix(.x$site))


# Define some functions in to make our lives easier.  The first one just computes the modeled reflectance
compute_rho <- function(K,solution_list) {
  band_list <- solution_list %>% split(.$band)
  gsvd_rho <- map(band_list,~(K %*% .x$value)) %>%
    bind_rows() %>%
    gather(key="band",value="value")


  return(gsvd_rho)
}



# Next we need to compute our comparisons across each band
# Function to rename the kernel values from 0 1 2 to the abbreviation



# Allows us to add a heading to our facets
prepender_b <- function(string, prefix = "Band ") {
  string_new=string %>% str_sub(-1)
  paste0(prefix,string_new)

}


# First a calculation to do the Taylor values
taylor_calculation <- function(measured_rho,modeled_rho) {
  sd_meas=1
  sd_gsvd = sd(modeled_rho)/sd(measured_rho)
  r = cor(modeled_rho,measured_rho)
  centered_rms = sd((measured_rho-mean(measured_rho))-((modeled_rho-mean(modeled_rho))))/sd(measured_rho)
  x_coord = sd_gsvd*r
  y_coord = sd_gsvd*sin(acos(r))
  return(data.frame(sd_meas,sd_gsvd,r,centered_rms,x_coord,y_coord))

}


# Next a way to get this all in the bands together
taylor_bands <- function(measured_rho,modeled_rho) {
  measured_band_list <- measured_rho %>% split(.$band)
  modeled_band_list <- modeled_rho %>% split(.$band)

  taylor_values <- map2(measured_band_list,modeled_band_list,~taylor_calculation(.x$value,.y$value)) %>%
    bind_rows(.id="band")

}

# This function will map over all sites to create the rho for each band
gsvd_rho <- map2(data_list,solution_list,~compute_rho(.x$K,.y))

# Finally let's get this humming
taylor_comparisons <- map2(data_list,gsvd_rho,~taylor_bands(.x$rho,.y)) %>%
  bind_rows(.id="site") %>%
  mutate(method='modeled')


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

taylor_rsq <- taylor_comparisons %>%
  mutate(method="GSVD") %>% ungroup()

joined_data <- rbind(taylor_rsq,taylor_mcd43) %>%
  left_join(data_points,by=c("site")) %>%
  left_join(lambda_values,by=c("site","band")) %>%
  filter(converged) # only look at sites than have converged

t_plot <- taylor_plot()

curr_plot <- t_plot +
  geom_point(data=joined_data,aes(x=x_coord,y=y_coord,color=method,shape=method),size=2) +
  facet_grid(.~band,labeller=labeller(kernel=label_parsed,band=prepender_b)) +
  labs(x="",y=expression(italic("\u03C3")[GSVD]),color="Inversion method",shape="Inversion method") +
  theme_bw() +
  theme(legend.position = "bottom",
        axis.text = element_text(size=14),
        axis.title=element_text(size=28),
        title=element_text(size=26),
        legend.text=element_text(size=12),
        legend.title=element_text(size=14),
        strip.text.x = element_text(size=12),
        strip.text.y = element_text(size=12),
        strip.background = element_rect(colour="white", fill="white")) +
  theme( panel.grid.major = element_blank(),
         panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"))




fileName <- paste0('manuscript-figures/reflectanceTaylor.png')
ggsave(fileName,plot=curr_plot,width=19,height=4.0,dpi=600)




