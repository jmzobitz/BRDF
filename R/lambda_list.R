#' Max smoothing lambda for 26 MODIS pixels in 2017.
#'
#' \itemize{
#'   \item band. Which band used
#'   \item lambda. Max lambda value
#'   \item converged. Were we able to find a value of lambda within the RMSE?
#' }
#'
#'
#' @docType data
#' @keywords datasets
#' @name lambda_list
#' @usage data(lambda_list)
#' @format A list with 26 elements, organized by site. Each element is a data frame contaitning a max lambda value, organized by band and if it converged. See the file process-gsvd-fluxnet.R in the data-raw folder

NULL
