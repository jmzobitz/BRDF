### 1. Call a site name
### NEED TO LOAD UP TIDYVERSE AND GEIGEN FIRST?


# Pull up the data
site_list <- fluxnet %>% split(.$site)
### 2.1 Compute the kernel matrices

# Compute the kernel matrices, as a list by site
data_list <-map(site_list,~kernel_matrix(.x$site))


# Compute the GSVD, using the package geigen, save it for later
gsvd_list <-map(data_list,gsvd_compute)
#save(gsvd_list,file='../Saved-Files-12.08/fluxnet-gsvd.Rda')
load('../Saved-Files-12.08/fluxnet-gsvd.Rda')
#use_data(gsvd_list,overwrite = TRUE)


### 4.1 Analyze the results to optimize across all bands (solution and norm)

# Compute the smoothing lambda's, saving them for later
lambda_list <- map2(gsvd_list,data_list,~gsvd_optimize(.x,.y$rho))
use_data(lambda_list,overwrite = TRUE)

### Select out a band

solution_list <- pmap(list(x=gsvd_list,y=lambda_list,z=data_list),.f=function(x,y,z){ gsvd_solution(x,y,z) })
use_data(solution_list,overwrite = TRUE)

# Process white sky albedo
albedo_list <- map(solution_list,albedo_compute)
use_data(albedo_list,overwrite = TRUE)





