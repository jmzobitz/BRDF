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
      weights <- data.frame(weight_value=array(1,dim=dim(small_data)[1])) %>%
        mutate(value =  if_else(small_data$time == time_value,small_data$value,weight_value)) %>%
        pull(weight_value)


      f1 <- lm(value ~ -1 + K_Iso + K_RossThick + K_LiSparse,data=small_data,weights = weights)

      while(sum(coefficients(f1)<0)>=1 ) {

        # Exit this loop if we have ALL the coefficients are 0
        if (sum(coefficients(f1)<0) ==3) {

          break
        }
        rhs <- paste(names(coefficients(f1))[coefficients(f1)>0],collapse = "+")
        fmla <- as.formula(paste("value ~ -1+",rhs))
        f1 <- lm(fmla,data=small_data,weights = weights)
      }
      results[[i]] <- data.frame(t(coefficients(f1)),time=min(time_value,365))

    }
  }

  # We need to re-run if any coefficients are zero, but this should be sufficient, just need to add the weights ...

  out_results <- results %>%
    bind_rows()

  # Convert the NAs to 0
  out_results[is.na(out_results)]<-0

  return(out_results)
}
