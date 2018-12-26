#' Compute the solution for the kernel weights for a GSVD decomposition
#'
#' \code{gsvd_solution} Computes solution for a GSVD matrix decomposition
#'
#' @param gsvdResult decomposition
#' @param lambda smoothness parameter - can be a vector of values
#' @param rho right hand side of the equation - is a data frame with the band, value, and measurement
#'
#' @return Solution to Krylov subspace solution
#' @examples
#'
#' # To be filled in later

#' @export


gsvd_solution<-function(gsvdResult,lambda,rho) {

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
      filter(band == band_vals[band_idx]) %>%
      select(value) %>%
      as.matrix()

    f0 = rep(0,n)  # The initialization of it all

    for (i in 1: k) {
      f0 = f0 + drop(t(U[,i])%*%rho_curr) * X[,i]
    }

    for (j in seq_along(lambda)) {
      filter = gamma^2/(gamma^2+lambda[j]^2)
      f=f0

      for (i in (k+1): m) {
        f = f + filter[i]*drop(t(U[,i])%*%rho_curr) * X[,i] / alpha[i]
      }

      f_results[[j]] <- f

    }

    out_little_f <- bind_cols(f_results)
    names(out_little_f) <- lambda # Assign a lambda value to each column
    f_grande[[band_idx]] <- out_little_f  %>% mutate(band = band_vals[band_idx])
  }

  out_f <- bind_rows(f_grande) %>% gather(key="lambda",value="f",-band)
  return(out_f)
}

