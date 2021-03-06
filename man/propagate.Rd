% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/propagate.R
\name{propagate}
\alias{propagate}
\title{Propagation function}
\usage{
propagate(realizations, model, n, ...)
}
\arguments{
\item{realizations}{a list where each element is a single Monte Carlo realizations 
if only one parameter/variable is considered uncertain; a list of such lists if more
than one parameter/variable is considered uncertain.}

\item{model}{model that is written as a function in R.}

\item{n}{number of Monte Carlo Runs.}

\item{...}{any further arguments that the model takes.}
}
\value{
Model output Monte Carlo realizations.
}
\description{
A function that runs a model repeatedly with Monte Carlo samples
of uncertain inputs.
}
\author{
Kasia Sawicka
}

