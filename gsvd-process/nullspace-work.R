load('../Saved-Files-12.08/fluxnet-gsvd-nosnow-flag.Rda')
yee_value <- data_list[[1]]
# This loads up gsvd_list

one_soln <- array(1,dim=c(365,1))
zero_soln <- array(0,dim=c(365,1))

r1 <- yee_value$rho %>% filter(band=="band3") %>% pull(value) %>% as.matrix()

N_matrix = rbind( c(one_soln,zero_soln,zero_soln),
           c(zero_soln,one_soln,zero_soln),
           c(zero_soln,zero_soln,one_soln) ) %>%
  as.matrix() %>% t()

my_soln <- t(yee_value$K %*% N_matrix) %*% (yee_value$K %*% N_matrix)
solve(my_soln,t(yee_value$K %*% N_matrix) %*% r1)
N_matrix %*% solve(my_soln,t(yee_value$K %*% N_matrix) %*% r1)

testr <- yee_value$K %*% N_matrix

