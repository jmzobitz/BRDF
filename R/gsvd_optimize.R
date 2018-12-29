#' Compute the solution for the kernel weights for a GSVD decomposition
#'
#' \code{gsvd_optimize} Computes residual and solution norm for a GSVD matrix decomposition
#'
#' @param gsvdResult GSVD decomposition
#' @param rho right hand side of the equation - is a data frame with the band, value, and measurement
#'
#' @return A vector of lambda values that optimize for each band.  Converged = True - able to determine the norm.  FALSE = max number of iterations reached.
#'
#' @examples
#'
#' # To be filled in later

#' @export


gsvd_optimize<-function(gsvdResult,rho) {




  # Set up some constants and initial values
  band_vals <- unique(rho$band)  # number of bands we have
  n_bands <- length(band_vals)



  # Make rho and lambda list structures
  rho_list <- rho %>% split(.$band)

  uncertainty_list <- band_uncertainty %>% split(.$band)

  # Initialize the first run
  # This will return a list with the norm and residual for each of our values. # initialize
  lambda_update <- map2(rho_list,uncertainty_list,~bisection(gsvdResult,.x,.y))   # Select the lambdas closest to our taget uncertainty



  tolCheck <- lambda_update %>%
    bind_rows(.id="band")


  # Write the results in
  results <- tolCheck





  return(results)
}

