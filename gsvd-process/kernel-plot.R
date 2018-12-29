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

big_data <- rbind(modisBRDF_data,gsvd_data)


prepender_k <- function(string){
 name <- string %>% str_replace_all("0","f[iso]") %>%
    str_replace_all("1","f[vol]") %>%
    str_replace_all("2","f[geo]")


  return(name)

}

big_data$kernel_variable <- prepender_k(big_data$kernel)


prepender_b <- function(string, prefix = "Reflectance Band ") {
  string_new=string %>% str_sub(-1)
  paste0(prefix,string_new)

}



####

####

kernelPlot   <- big_data %>%
  mutate(site = fct_relevel(site, site_read),
         kernel_variable = fct_relevel(kernel_variable, c("f[iso]","f[vol]","f[geo]"))) %>%
  ggplot(aes(x=time,y=value,color=method,shape=method)) + geom_point() +
  facet_grid(site~band+kernel_variable,labeller=labeller(kernel_variable=label_parsed,band=prepender_b)) +
  labs(x="Day of Year", y="Kernel weights",color="Method",shape="Method") +
  theme(axis.text = element_text(size=14),
        axis.title=element_text(size=28),
        title=element_text(size=26),
        legend.text=element_text(size=12),
        legend.title=element_text(size=16)) +
  theme(legend.position="bottom") +
  theme(strip.text.x = element_text(size=12),
        strip.text.y = element_text(size=12)) +
  scale_x_continuous(breaks = c(1,90,180,270,365))

fileName <- paste0('manuscript-figures/kernelPlot.png')
ggsave(fileName,plot=kernelPlot,width=14)

