# Want to randomly sample from IT-Ca1 (100, 75, 50, 25) of initial data

# Run a LS and a GSVD estimate
# Compare kernel weights, show results from band 2
# Taylor diagrams for all bands

library(tidyverse)
library(devtools)
library(BRDF)
# Pull up the data
site_data <- fluxnet %>% filter(site=="IT-CA1")


# ### Compute the least squares solutions
ls_sample <- function(input_data,sample_pct) {

  site_process <- input_data %>%
    sample_frac(sample_pct) %>%
    gather(key=band,value=value,band1:band7) %>%
    split(.$band) %>%
    map(.f=ls_solution) %>%
    bind_rows(.id="band")

  return(site_process)

}

percentages <- c(1,0.75,0.5,0.25)

# # Pull up the data
 ls_results_sample <- percentages %>%
   map(.f=~ls_sample(site_data,.x))

 names(ls_results_sample) <- percentages

 ls_results_sample <- ls_results_sample %>% bind_rows(.id="pct")




 ### Now do the GSVD approach

gsvd_sample <- function(input_data,sample_pct) {

  inData <- input_data %>%
    sample_frac(sample_pct)

  t <- 365 # Number of days in 2017
  n <- 3  # number of kernels

  B = formBMatrix(n*t,t)

  # Determine the reflectance data
  rho <- inData %>% select(6:12) %>%
    gather(key="band",value = "value",1:7)


  K <- as.array(array(0, dim=c(dim(inData)[1],n*t)))

  kernelData <- inData %>% select(3:5) %>% as.matrix()

  colIndices <- inData$time

  # Ok, now we want to get all the K values set up:
  for (i in seq_along(colIndices)) {
    columnSelect <- seq(from=colIndices[i],to=n*t,by=t)
    K[i,columnSelect] <- kernelData[i,]

  }


  data_values <- list(K=K,B=B,rho=rho,time=colIndices)

  # Compute the GSVD, using the package geigen, save it for later
  gsvd_values <-gsvd_compute(data_values)

  # Compute the smoothing lambda's, saving them for later
  lambda_values <- gsvd_optimize(gsvd_values,data_values$rho)





  ### Select out a band

  solution_values <- gsvd_solution(gsvd_values,lambda_values,data_values)


  return(solution_values)


}

# # Pull up the data
gsvd_results_sample <- percentages %>%
  map(.f=~gsvd_sample(site_data,.x))

names(gsvd_results_sample) <- percentages

gsvd_results_sample <- gsvd_results_sample %>% bind_rows(.id="pct")


## Ok, now we need to plot them together
site_read = c("AU-Lox","IT-CA1","ZM-Mon","JP-MBF","DE-Hai","US-Wi3")
band_read = c("band1","band2")

# filter out our data and the mcd4s
modisBRDF_data <- modisBRDF %>%
  filter(site == 'IT-CA1' ) %>%
  mutate(method='MCD43A1',
         pct = NA) %>%
  select(-site)




gsvd_data_sample <- gsvd_results_sample %>%
  mutate(method='GSVD')

ls_data_sample <- ls_results_sample %>%
  rename("0"=K_Iso,"1"=K_RossThick,"2"=K_LiSparse) %>%
  gather(key=kernel,value=value,"0","1","2") %>%
  mutate(method='Laplace')

big_data <- rbind(modisBRDF_data,gsvd_data_sample,ls_data_sample)

kernel_names <- c(
  `0` = "Isotropic",
  `1` = "Volumetric",
  `2` = "Geometric"
)





kernel_sample_plot <- big_data %>%
  filter(band=='band2',
         method !='MCD43A1') %>%
  ggplot(aes(x=time,y=value)) + geom_point(aes(color=pct)) +
  geom_line(data=subset(modisBRDF,band=='band2' & site=='IT-CA1'),aes(x=time,y=value,color='MCD43A1')) +
    ylim(c(0,1)) +
  facet_grid(method~kernel,labeller = labeller(kernel = as_labeller((kernel_names)))) +
  labs(x="Day of year", y="Kernel weight",color="Percentile") +
  scale_color_manual(name="Data Utilized",
                     values = c("#F8766D","#7CAE00", "#00BFC4", "#C77CFF", "#000000"),
                       labels=c("25%", "50%", "75%","100%","MCD43A1")) +
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
         panel.grid.minor = element_blank(), axis.line = element_line(colour = "black")) +
  scale_x_continuous(breaks = c(1,90,180,270,365)) + ylim(c(0,1))


fileName <- paste0('manuscript-figures/kernel-sample-plot.png')
ggsave(fileName,plot=kernel_sample_plot,height=4.0,dpi=600)

# Now compare with mcd43 in terms of Taylor diagrams
# Allows us to add a heading to our facets
prepender_b <- function(string, prefix = "Band ") {
  string_new=string %>% str_sub(-1)
  paste0(prefix,string_new)

}


##  Taylor Plot for modis
##########

taylor_data <- rbind(gsvd_data_sample,ls_data_sample) %>%
  inner_join(modisBRDF_data,by=c("time","kernel","band")) %>%
  select(-method.y,pct.y) %>%
  group_by(method.x,pct.x,band,kernel) %>%
  summarize(
    sd_meas=1,
    sd_gsvd = sd(value.x)/sd(value.y),
    r = cor(value.x,value.y),
    centered_rms = sd((value.x-mean(value.y))-((value.x-mean(value.x))))/sd(value.y),
    x_coord = sd_gsvd*r,
    y_coord = sd_gsvd*sin(acos(r))
  ) %>%
  ungroup()


t_plot <- taylor_plot()

curr_plot <- t_plot +
  geom_point(data=taylor_data,aes(x=x_coord,y=y_coord,color=pct.x,shape=method.x),size=3) +
  facet_grid(kernel~band,labeller=labeller(kernel=as_labeller((kernel_names)),band=prepender_b)) +
  labs(x="",y=expression(italic("\u03C3")),color="Data Utilized",shape="Inversion method") +
  scale_color_discrete(labels=c("25%", "50%", "75%","100%")) +
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




fileName <- paste0('manuscript-figures/taylorSample.png')
ggsave(fileName,plot=curr_plot,width=18,height=7)






