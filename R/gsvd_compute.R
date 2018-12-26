#' Compute the Generalized Singular Value Decomposition for two matrices
#'
#' \code{gsvd_compute} Computes solution for a GSVD matrix decomposition
#'
#' @param kernel_values A matrix of kernel weights from function kernel_matrix
#'
#' @return GSVD decomposed matrices
#' @examples
#'
#' # To be filled in later

#' @importFrom geigen gsvd
#' @importFrom geigen gsvd.R
#' @export


gsvd_compute<-function(kernel_values) {

  gsvdResult <- gsvd(kernel_values$K,kernel_values$B)

  # Invert the upper triangle R matrix
  R = gsvd.R(gsvdResult)
  gsvdResult$invR = solve(R)


  return(gsvdResult)

}



