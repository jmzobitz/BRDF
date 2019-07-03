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
      out_value <- data.frame(t(coefficients(f1)))
      out_value[is.na(out_value)] <- 0 # Set NA values to 0

      # Exit this loop if we have ALL the coefficients are 0
      if (sum(out_value<0) ==3) {
        out_value[names(out_value)] <- 0
        out_value[1] <- 1  # Set the first kernel weight to 1

      } else {

        while(sum(out_value<0)>0 ) {

          # Set negative values to zero
          out_value[out_value<0] <- 0
          # Formula for RHS
          rhs <- paste(names(out_value)[out_value>0],collapse = "+")

           if (nchar(rhs)==0) {
          #
          #
          #
             break
           }

          fmla <- as.formula(paste("value ~ -1+",rhs))
          f1 <- lm(fmla,data=small_data,weights = weights)
          updated_coeff <- data.frame(t(coefficients(f1)))
          updated_coeff[is.na(updated_coeff)] <- 0 # Set NA values to 0
          out_value[names(updated_coeff)] <- updated_coeff

        }

      }


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
