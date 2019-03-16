#' Compute the solution for the kernel weights for a GSVD decomposition
#'
#' \code{gsvd_solution_compute} Computes residual and solution norm for a GSVD matrix decomposition
#'
#' @param gsvdResult GSVD decomposition
#' @param lambda_df smoothness parameter - can be a vector of values - must be a data frame
#' @param rho right hand side of the equation - is a data frame with the band, value, and measurement
#'
#' @return Data frame that contains the residual and solution norms with the associated lambda and reflectance band
#' @examples
#'
#' # To be filled in later

#' @export


gsvd_solution_compute<-function(gsvdResult,lambda_df,rho) {

  lambda <- lambda_df$lambda
  # Identify size of lambda values and number of bands
  nLambda = length(lambda)  # Number of lambdas we have in our sequence

  rho_curr <- rho %>%
    #   filter(band == band_vals[band_idx] ) %>%
    select(value) %>%
    as.matrix()



  # List to hold the results
  f_results <- vector("list", nLambda)  # For each of the lambdas
  #  f_grande <- vector("list",length(band_vals))  # For each of the bands


  # Identify GSVD matrices and key dimensions
  U = gsvdResult$U
  V = gsvdResult$V
  Q = gsvdResult$Q
  invR = gsvdResult$invR

  n = dim(Q)[2]
  m = gsvdResult$m
  k = gsvdResult$k  #The first k generalized singular values are infinite.
  l = gsvdResult$l  #effective rank of the input matrix B. The number of finite generalized singular values after the first k infinite ones.
  r = k+l


  # Now start to form up the solution
  # Doing the multiplication, split Q = [Q1 Q2], where Q1 = first n-r columns of Q, Q2 last r columns
  if (n-r > 0){
    zeroMat = matrix(0,nrow=r,ncol=n-r)
    iMat = cbind(diag(1,nrow=n-r,ncol=n-r),t(zeroMat))
    oInvR = cbind(zeroMat,invR)
    newInvR = rbind(iMat,oInvR)
  } else {
    newInvR = invR
  }

  X = Q %*% newInvR

  alpha = gsvdResult$alpha  # Singular values with sigma matrix
  beta = gsvdResult$beta  # Singular values with M matrix

  #####
  f0 = rep(0,n)  # The initialization of it all

  for (j in seq_along(lambda)) {
    filter = alpha/(alpha^2+beta^2*lambda[j]^2)
    f=f0

    for (i in 1: m) {
      f = f + filter[idx]*drop(t(U[,idx])%*%rho_curr) * X[,i]
    }

    f_results[[j]] <- f

  }
  ######
#
#   for (j in seq_along(lambda)) {
#     filter = alpha/(alpha^2+beta^2*lambda[j]^2)
#    g = rep(0,n)
#
#   if (r <= m) {
#     for(i in (n-r+1):n) {
#       idx <- n-r-i
#       g[i]<-filter[idx]*drop(t(U[,idx])%*%rho_curr)
#       }
#   } else { # m < r
#     for(i in (n-r+1):(n-r+m)) {
#       idx <- n-r-i
#       g[i]<-filter[idx]*drop(t(U[,idx])%*%rho_curr) }
#   }
#
#
#     f_results[[j]] <- X %*% g


#}

  out_little_f <- bind_cols(f_results)
  names(out_little_f) <- lambda

  out_soln <- out_little_f %>%
    gather(key="lambda",value="value") %>%
    mutate(time=rep(1:365,3),
           kernel=rep(c("0","1","2"),each=365) ) %>%
    select(-lambda)



  return(out_soln)
}

