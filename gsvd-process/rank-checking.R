# Compute the rank of different matrices

# Load up the GSVD results
library(tidyverse)
library(BRDF)
load('../Saved-Files-12.08/fluxnet-gsvd.Rda')
r_vals <- list()
k_vals <- list()
l_vals <- list()
m_vals <- list()
for(i in 1:length(gsvd_list)) {k_vals[i]=gsvd_list[[i]]$k}
for(i in 1:length(gsvd_list)) {l_vals[i]=gsvd_list[[i]]$l}
for(i in 1:length(gsvd_list)) {r_vals[i]=gsvd_list[[i]]$l+gsvd_list[[i]]$k}

bind_rows(r_vals,.id="site")
data.frame(r_vals)
data.frame(k_vals)
data.frame(l_vals)

site_list <- fluxnet %>% split(.$site)
data_list <-map(site_list,~kernel_matrix(.x$site))
# Pull up the data
library(Matrix)

rankK_vals <- list()
rankB_vals <- list()
dim_K_vals <- list()
rankKB_vals <- list()

for(i in 1:length(data_list)) {rankKB_vals[i]=rankMatrix(rbind(data_list[[i]]$K,data_list[[i]]$B))}

for(i in 1:length(data_list)) {
rankB_vals[i]=rankMatrix(data_list[[i]]$B)
dim_K_vals[i] = dim(data_list[[i]]$K)[1]
}

for(i in 1:length(data_list)) {rankK_vals[i]=rankMatrix(data_list[[i]]$K)
rankB_vals[i]=rankMatrix(data_list[[i]]$B)
dim_K_vals[i] = dim(data_list[[i]]$K)[1]
}
rankMatrix(data_list$`AU-Lox`$K)


rankKB_vals %>% data.frame()

