#' Compute the relative proximity of a solution in relation to an uncertainty.
#'
#' \code{max_norm} Determines where a norm (residual or solution) is within a certain tolerance, iteratively narrowing down a list of lambda values.
#'
#' @param norm_result Result of doing the gsvd_norm function
#' @param uncertainty Target level of the norm we want to acheive
#'
#' @return Data frame that contains the updated lambda min and max values
#' @examples
#'
#' # To be filled in later

#' @export

max_norm<-function(norm_result,uncertainty) {
  # Return the max_value and lambda associated with the residual

  compare_norm<-norm_result %>%
    filter(norm=='residual') %>%  # Filter out residuals
    mutate(result_diff = result-uncertainty$sigma) # set up a difference vector

  print(compare_norm)
  test_idx <- which(compare_norm$result_diff>0)

  if (length(test_idx)>0) {
    min_idx = min(test_idx)
  } else {min_idx <- length(compare_norm$result_diff) }


  # Now make
  end_idx<-max(1,min_idx)
  start_idx <- max(1,min_idx-1)
  print(min_idx)
  print(c(start_idx,end_idx))
  lambda_return <- compare_norm %>%
    select(lambda,result,result_diff) %>%
    slice(c(start_idx,end_idx)) %>%
    mutate(tol_check = log10(abs(result_diff))) %>%
    select(-result_diff)

  return(lambda_return)



}
