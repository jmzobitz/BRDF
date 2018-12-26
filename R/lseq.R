#' Compute the a logarithmically spaced sequence
#'
#' \code{lseq} Computes solution for a GSVD matrix decomposition
#'
#' @param from Starting value
#' @param to Ending Value
#' @param length.out Size of the sequence
#'
#' @return Vector of logarithmic points
#' @source From package emdbook: \url{https://www.rdocumentation.org/packages/emdbook/versions/1.3.10/topics/lseq}
#'
#' @examples
#'
#' lseq(1,100000,5)

#' @export


lseq <- function(from=1, to=100000, length.out=6) {
  # logarithmic spaced sequence
  # blatantly stolen from library("emdbook"), because need only this
  exp(seq(log(from), log(to), length.out = length.out))
}
