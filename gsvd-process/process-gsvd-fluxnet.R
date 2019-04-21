### 1. Call a site name
### NEED TO LOAD UP TIDYVERSE AND GEIGEN FIRST?
library(tidyverse)

# Pull up the data
site_list <- fluxnet %>% split(.$site)
### 2.1 Compute the kernel matrices

# Compute the kernel matrices, as a list by site
data_list <-map(site_list,~kernel_matrix(.x$site))


# Compute the GSVD, using the package geigen, save it for later
#gsvd_list <-map(data_list,gsvd_compute)
#save(gsvd_list,file='../Saved-Files-12.08/fluxnet-gsvd.Rda')

load('../Saved-Files-12.08/fluxnet-gsvd.Rda')



### 4.1 Analyze the results to optimize across all bands (solution and norm)

# Compute the smoothing lambda's, saving them for later
lambda_list <- map2(gsvd_list,data_list,~gsvd_optimize(.x,.y$rho))


### Select out a band

solution_list <- pmap(list(x=gsvd_list,y=lambda_list,z=data_list),.f=function(x,y,z){ gsvd_solution(x,y,z) })


# Process white sky albedo
albedo_list <- map(solution_list,albedo_compute)

# Make our plots
source("gsvd-process/albedo-plot.R")
source("gsvd-process/albedo-taylor-plot.R")
source("gsvd-process/data-plot.R")
source("gsvd-process/kernel-plot.R")
source("gsvd-process/kernel-taylor-plot.R")
source("gsvd-process/reflectance-taylor-plot.R")
source("gsvd-process/lambda-boxplot.R")
source("gsvd-process/lCurve-plot.R")





