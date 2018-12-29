#' Albedo solution kernel values
#'
#' \itemize{
#'   \item time. Day of the year in 2017
#'   \item band. Reflectance band (1-7)
#'   \item value. Albedo measurement
#'   \item type. Black sky or white sky albedo. Currently only contains white-sky albedo - for black-sky albedo we need solar noon
#' }
#'
#'
#' @docType data
#' @keywords datasets
#' @name albedo_list
#' @usage data(albedo_list)
#' @format A list with 26 elements, each element is a data frame, organized by site. See the file process-gsvd-fluxnet.R in the data-raw folder

NULL
