#' Compute the solution for the kernel weights for a GSVD decomposition
#'
#' \code{gsvd_solution} Computes solution for a GSVD matrix decomposition
#'
#' @param gsvdResult decomposition
#' @param lambda smoothness parameter - is a list of values
#' @param data right hand side of the equation - is a list of values with the band, value, and measurement
#'
#' @return Solution to Krylov subspace solution
#' @examples
#'
#' # To be filled in later

#' @export


gsvd_solution<-function(gsvdResult,lambda,data) {


  # Make rho and lambda list structures
  data_list <- data$rho %>% split(.$band)

  lambda_list <- lambda %>% split(.$band)

  solution_update <- map2(lambda_list,data_list,~gsvd_solution_compute(gsvdResult,.x,.y))   # Select the lambdas closest to our taget uncertainty

  # Rename the columns so we can plot
  time_vector =rep(1:365,3)
  kernel=rep(c(0,1,2),each=365)

  out_f <- solution_update %>%
    bind_rows(.id="band")


  #
  return(out_f)
}

