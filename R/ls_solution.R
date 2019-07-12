#' Compute the solution for the kernel weights for a least squares decomposition
#'
#' \code{ls_solution} Computes solution for a GSVD matrix decomposition
#'
#' @param site_name Name of the site

#' @return Least squares weighted solution
#' @examples
#'
#' # To be filled in later

#' @import dplyr
#' @import greybox

#' @export


ls_solution <- function(site_name) {

  t <- 16 # Number of days in 2017
  n <- 3  # number of kernels


  start_index <- 1
  end_index <- t

  results <- list()
  for (i in seq_along(1:365)) {
    small_data <- site_name %>% filter(between(time,i,(i-1)+t))

    if (dim(small_data)[1]>=3) {   # 3 is the minimum number we need to do the inversion.

      time_value <- (i-1) + t/2

      f1 <- alm(value ~ K_RossThick + K_LiSparse,data=small_data,distribution="dlaplace",scale=11.5)
      out_value <- data.frame(t(coefficients(f1)))


      names(out_value)[1] <- "K_Iso"


      results[[i]] <- data.frame(out_value,time=min(time_value,365))

    }
  }

  # We need to re-run if any coefficients are zero, but this should be sufficient, just need to add the weights ...

  out_results <- results %>%
    bind_rows()

  # Convert the NAs to 0
  out_results[is.na(out_results)]<-0

  return(out_results)
}

