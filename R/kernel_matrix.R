#' Compute the matrix for BRDF inversion
#'
#' \code{kernel_matrix} Computes the B, K, and rho matrices for a given site in preparation to do the GSVD
#'
#' @param site_name Name of the site

#' @return A list that contains the K, B, and rho matrix, and time points
#' @examples
#'
#' kernel_data <- kernel_matrix('AU-Lox')

#' @import dplyr
#' @export


kernel_matrix <-function(site_name) {

  if (!site_name %in% fluxnet$site) stop("Site is not in fluxnet dataset.")


  inData = fluxnet %>% filter(site==site_name)

  t <- 365 # Number of days in 2017
  n <- 3  # number of kernels

  B = formBMatrix(n*t,t)

  # Determine the reflectance data
  rho <- inData %>% select(6:12) %>%
    gather(key="band",value = "value",1:7)


  K <- as.array(array(0, dim=c(dim(inData)[1],n*t)))

  kernelData <- inData %>% select(3:5) %>% as.matrix()

  colIndices <- inData$time

  # Ok, now we want to get all the K values set up:
  for (i in seq_along(colIndices)) {
    columnSelect <- seq(from=colIndices[i],to=n*t,by=t)
    K[i,columnSelect] <- kernelData[i,]

  }


  return(list(K=K,B=B,rho=rho,time=colIndices))

}





