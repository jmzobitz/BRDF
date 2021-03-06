# Figure 4: kernel weight plot over time




site_read = c("AU-Lox","IT-CA1","ZM-Mon","JP-MBF","DE-Hai","US-Wi3")
band_read = c("band1","band2")

# filter out our data and the mcd4s
modisBRDF_data <- modisBRDF %>%
  filter(site %in% site_read & band %in% band_read ) %>%
  mutate(method='MCD43A1')

gsvd_data <- solution_list %>% bind_rows(.id="site") %>%
  filter(site %in% site_read & band %in% band_read ) %>%
  mutate(method='GSVD')

ls_data <- ls_results %>%
  rename("0"=K_Iso,"1"=K_RossThick,"2"=K_LiSparse) %>%
  gather(key=kernel,value=value,"0","1","2") %>%
  filter(site %in% site_read & band %in% band_read ) %>%
  mutate(method='WLS')

big_data <- rbind(modisBRDF_data,gsvd_data,ls_data)


prepender_k <- function(string){
 name <- string %>% str_replace_all("0","Isotropic") %>%
    str_replace_all("1","Volumetric") %>%
    str_replace_all("2","Geometric")


  return(name)

}

big_data$kernel_variable <- prepender_k(big_data$kernel)


prepender_b <- function(string, prefix = "Band ") {
  string_new=string %>% str_sub(-1)
  paste0(prefix,string_new)

}


kernelPlot   <- big_data %>%
  mutate(site = fct_relevel(site, site_read),
         kernel_variable = fct_relevel(kernel_variable, c("Isotropic","Volumetric","Geometric"))) %>%
  ggplot(aes(x=time,y=value,color=method,shape=method)) + geom_point() +
  facet_grid(site~band+kernel_variable,labeller=labeller(kernel_variable=label_parsed,band=prepender_b)) +
  labs(x="Day of year", y="Kernel weights",color="Method",shape="Method") +
  theme_bw() +
  theme(axis.text = element_text(size=14),
        axis.title=element_text(size=28),
        title=element_text(size=26),
        legend.text=element_text(size=12),
        legend.title=element_text(size=16)) +
  theme(legend.position="bottom") +
  theme(strip.text.x = element_text(size=12),
        strip.text.y = element_text(size=12)) +
  theme(strip.background = element_rect(colour="white", fill="white")) +
  scale_x_continuous(breaks = c(1,90,180,270,365)) + ylim(c(0,1))


fileName <- paste0('manuscript-figures/kernelPlot.png')
ggsave(fileName,plot=kernelPlot,width=14,dpi=600)

