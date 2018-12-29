#' Solution kernel weights for max smoothing lambda for 26 MODIS pixels in 2017.
#'
#' \itemize{
#'   \item band. Reflectance bandNUM, where NUM is (1-7)
#'   \item time. Day of the year in 2017
#'   \item value. Calculated value of kernel weight
#'   \item kernel. Code for kernel 0 = Isometric, 1 = Ross Thick kernel, 2 = Li Sparse kernel
#' }
#'
#'
#' @docType data
#' @keywords datasets
#' @name solution_list
#' @usage data(solution_list)
#' @format A list with 26 elements, each element is a data frame, organized by site. See the file process-gsvd-fluxnet.R in the data-raw folder

NULL
