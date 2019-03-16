#' Compute the relative proximity of a solution in relation to an uncertainty.
#'
#' \code{bisection} Determines where a norm (residual or solution) is within a certain tolerance, iteratively narrowing down a list of lambda values.
#'
#' @param norm_result Result of doing the gsvd_norm function
#' @param uncertainty Target level of the norm we want to acheive
#'
#' @return Data frame that contains the updated lambda min and max values
#' @examples
#'
#' # To be filled in later

#' @export

bisection<-function(gsvdResult,rho,uncertainty) {
  # Return the max_value and lambda associated with the residual
  nLambda <- 100
  lambda_init <- c(0,lseq(1E-6,1E6,length.out=nLambda-1))  # Do a logarithmic sequence initially to hone in

  norm_result <- gsvd_norm(gsvdResult,lambda_init,rho)
  compare_norm<-norm_result %>%
    filter(norm=='rmse') %>%  # Filter out residuals
    mutate(result_diff = result-uncertainty$sigma,
           sign =sign(result_diff)) # set up a difference vector

  # residual will be an increasing function of lambda
  a <- compare_norm %>%
    filter(sign==-1) %>%
    select(lambda) %>%
    tail(n=1) %>%
    as.vector()

  b <- compare_norm %>%
    filter(sign==1) %>%
    select(lambda) %>%
    head(n=1) %>%
    as.vector()

# If we have a case where the target value is not in our list.
  if (dim(a)[1]==0 & dim(b)[1]!=0) {
    out_return <- head(compare_norm,n=1) %>% select(lambda)
    out_return$converged = FALSE

    return(out_return)
  }

  if (dim(a)[1]!=0 & dim(b)[1]==0) {
    out_return <- tail(compare_norm,n=1) %>% select(lambda)
    out_return$converged = FALSE

    return(out_return)
  }


  mid <- 0.5*(a+b)

  lambda_curr <- (c(a$lambda,mid$lambda,b$lambda))

  max_iter = 100
  tolerance=1E-3

  for (i in 1:max_iter) {

    norm_result<-gsvd_norm(gsvdResult,lambda_curr,rho)

    compare_norm<-norm_result %>%
      filter(norm=='rmse') %>%  # Filter out residuals
      mutate(result_diff = result-uncertainty$sigma) # set up a difference vector


    a <- lambda_curr[1]
    mid <- lambda_curr[2]
    b <- lambda_curr[3]

    f_a <- compare_norm$result_diff[1]
    f_mid <- compare_norm$result_diff[2]
    f_b <- compare_norm$result_diff[3]


    # If the function equals 0 at the midpoint or the midpoint is below the desired tolerance, stop the
    # function and return the root.
    if ((abs(f_mid) < tolerance) || ((b - a) / 2) < tolerance) {
      out_return <-compare_norm %>% select(lambda)

      out_return$converged = TRUE
      return(out_return[2,])  # Return midpoint value
    }

    # If another iteration is required,
    # check the signs of the function at the points c and a and reassign
    # a or b accordingly as the midpoint to be used in the next iteration.
    ifelse(sign(f_mid) == sign(f_a),
    lambda_curr[1] <- mid,
    lambda_curr[3] <- mid)


    lambda_curr[2] <- 0.5*(lambda_curr[1]+lambda_curr[3])
    #lambda_curr <- lseq(lambda_curr[1],lambda_curr[3],length.out = 3)
  }


  out_return <- compare_norm %>% select(lambda)
  out_return$converged = FALSE
  return(out_return[2,])  # Return midpoint value

}
