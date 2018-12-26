#' Compute the solution for the kernel weights for a GSVD decomposition
#'
#' \code{gsvd_norm} Computes residual and solution norm for a GSVD matrix decomposition
#'
#' @param gsvdResult GSVD decomposition
#' @param lambda smoothness parameter - can be a vector of values
#' @param rho right hand side of the equation - is a data frame with the band, value, and measurement
#'
#' @return Data frame that contains the residual and solution norms with the associated lambda and reflectance band
#' @examples
#'
#' # To be filled in later

#' @export


gsvd_norm<-function(gsvdResult,lambda,rho) {


  # Identify size of lambda values and number of bands
  nLambda = length(lambda)  # Number of lambdas we have in our sequence
  band_vals <- unique(rho$band)

  # List to hold the results
  f_results <- vector("list", nLambda)  # For each of the lambdas
  f_grande <- vector("list",length(band_vals))  # For each of the bands


  # Identify GSVD matrices and key dimensions
  U = gsvdResult$U
  V = gsvdResult$V
  Q = gsvdResult$Q
  invR = gsvdResult$invR

  n = dim(Q)[2]
  m = gsvdResult$m
  k = gsvdResult$k  #The first k generalized singular values are infinite.
  l = gsvdResult$l  #effective rank of the input matrix B. The number of finite generalized singular values after the first k infinite ones.
  r = dim(invR)[1]


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
  mu = gsvdResult$beta  # Singular values with M matrix
  gamma = gsvdResult$alpha/gsvdResult$beta


  for (band_idx in seq_along(band_vals)) {
    rho_curr <- rho %>%
      filter(band == band_vals[band_idx] ) %>%
      select(value) %>%
      as.matrix()

    f0 = rep(0,n)  # The initialization of it all

    # Formula given in pg 72, Hansen Rank Deficient and discrete ill posed problems
    delta0 <- (diag(m)-U%*%t(U))%*%rho_curr

    for (j in seq_along(lambda_band)) {
      filter = gamma^2/(gamma^2+lambda[j]^2)
      Bf=f0
      epsilon = delta0
      # Formula given in pg 72, Hansen Rank Deficient and discrete ill posed problems
      for (i in (k+1): m) {
        Bf = Bf + filter[i]*drop(t(U[,i])%*%rho_curr) * Q[,i] / gamma[i]

        epsilon = epsilon + (1-filter[i])*drop(t(U[,i])%*%rho_curr)*U[,i]
      }

      f_results[[j]] <-data.frame(residual=norm(epsilon,type="2"),
                                  solution=norm(Bf,type="2"),
                                  lambda=lambda[j])
    }

    out_little_f <- bind_rows(f_results)


    out_little_f$band <- band_vals[band_idx]
    f_grande[[band_idx]] <- out_little_f
  }

  out_f <- bind_rows(f_grande) %>%
    gather(key="norm",value="result",residual,solution) %>%
    arrange(lambda,band)
  return(out_f)
}

