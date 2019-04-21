#' Compute the solution for the kernel weights for a GSVD decomposition
#'
#' \code{gsvd_norm} Computes residual and solution norm for a GSVD matrix decomposition
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


gsvd_norm<-function(gsvdResult,lambda_df,rho) {
  # Putting something in here
  lambda <- lambda_df
  # Identify size of lambda values and number of bands
  nLambda = length(lambda)  # Number of lambdas we have in our sequence

  # List to hold the results
  f_results <- vector("list", nLambda)  # For each of the lambdas

  # Identify GSVD matrices and key dimensions
  U = gsvdResult$U
  V = gsvdResult$V
  Q = gsvdResult$Q


  n = dim(Q)[2]
  m = gsvdResult$m
  k = gsvdResult$k  #The first k generalized singular values are infinite.
  l = gsvdResult$l  #effective rank of the input matrix B. The number of finite generalized singular values after the first k infinite ones.
  r = k+l


  alpha = gsvdResult$alpha  # Singular values with sigma matrix
  beta = gsvdResult$beta  # Singular values with M matrix


    rho_curr <- rho %>%
      select(value) %>%
      as.matrix()

    for (j in seq_along(lambda)) {

      filter <- alpha/(alpha^2+lambda[j]^2*beta^2)

      Bf=rep(0,n)
      epsilon <- rep(0,m)

      if ( r <= m) {
       # Solution norm
         for (i in 1:l) {
          Bf[i] = filter[i]*beta[i]*drop(t(U[,i])%*%rho_curr)
         }
        # Residual norm
        for (i in 1:r) {
          epsilon[i]<- (1-filter[i]*alpha[i])*drop(t(U[,i])%*%rho_curr)
        }
        for (i in (r+1):m) {
          epsilon[i]<- drop(t(U[,i])%*%rho_curr)
        }
      } else {

        # Solution norm
        for (i in 1:m) {
          Bf[i] = filter[i]*beta[i]*drop(t(U[,i])%*%rho_curr)
        }
        # Residual norm
        for (i in 1:m) {
          epsilon[i]<- (1-filter[i]*alpha[i])*drop(t(U[,i])%*%rho_curr)
          }
      }

      f_results[[j]] <-data.frame(rmse = sd(epsilon),
                                  residual=norm(epsilon,type="2"),
                                  solution=norm(Bf,type="2"),
                                  lambda=lambda[j])
    }

    out_little_f <- bind_rows(f_results)





  out_f <-out_little_f %>%
    gather(key="norm",value="result",rmse,residual,solution) %>%
    arrange(lambda)
  return(out_f)
}

