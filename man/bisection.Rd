% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/bisection.R
\name{bisection}
\alias{bisection}
\title{Compute the relative proximity of a solution in relation to an uncertainty.}
\usage{
bisection(gsvdResult, rho, uncertainty)
}
\arguments{
\item{uncertainty}{Target level of the norm we want to acheive}

\item{norm_result}{Result of doing the gsvd_norm function}
}
\value{
Data frame that contains the updated lambda min and max values
}
\description{
\code{bisection} Determines where a norm (residual or solution) is within a certain tolerance, iteratively narrowing down a list of lambda values.
}
\examples{

# To be filled in later
}
