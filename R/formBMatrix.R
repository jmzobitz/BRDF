#' Internal function to create the first difference matrix
#'
#' \code{formBmatrix} Computes the B matrix (currently the first order difference) used in the BRDF kernel inversion.  Accounts for multiple observations in a given day.
#'
#' @param newDim Number of rows in the matrix
#' @param kernelSize Number of BRDF kernels

#' @return The B matrix of first order difference. See Quaife and Lewis 2010
#' @examples
#'
#' B <- formBmatrix(365,3)



formBMatrix <- function(newDim,kernelSize) {


# Change B so that it is an eye
tridiag <- function(upper, lower, main){
  out <- matrix(0,length(main),length(main))
  diag(out) <- main
  indx <- seq.int(length(upper))
  out[cbind(indx+1,indx)] <- lower
  out[cbind(indx,indx+1)] <- upper
  return(out)
}


Bmatrix = tridiag(rep(0,length=newDim-1), rep(-1,length=newDim-1), rep(1,length=newDim))
zeroRows = seq(1,newDim,by=kernelSize)
Bmatrix[zeroRows,]=0  # Make sure we don't go across the timestep

return(Bmatrix)
}
