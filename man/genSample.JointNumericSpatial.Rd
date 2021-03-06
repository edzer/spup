% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/genSample.JointNumericSpatial.R
\name{genSample.JointNumericSpatial}
\alias{genSample.JointNumericSpatial}
\title{Generating Monte Carlo sample from a list of uncertain objects that are cross-correlated.}
\usage{
\method{genSample}{JointNumericSpatial}(UMobject, n, samplemethod, p = 0,
  asList = TRUE, debug.level = 1, ...)
}
\arguments{
\item{UMobject}{object of a class JointNumericSpatial. Output of defineMUM().}

\item{n}{Integer. Number of Monte Carlo realizations.}

\item{samplemethod}{"ugs" for spatially cross-correlated errors, "randomSampling" for joint PDF of 
non-spatial variables, "lhs" if no correlation of errors is considered.}

\item{p}{A vector of quantiles. Optional. Only required if sample method is "lhs".}

\item{asList}{Logical. If TRUE return sample in a form of a list, if FALSE returnsample in a format
of distribution parameters.}

\item{debug.level}{integer; set gstat internal debug level, see below for useful values. 
If set to -1 (or any negative value), a progress counter is printed.}

\item{...}{Additional parameters that may be passed, e.g. in
the "ugs" method. See examples.}
}
\value{
A Monte Carlo sample of the variables of interest. If asList = TRUE returns
list of all samples as lists.
}
\description{
Uncertain objects are described by joint PDF or a list from independent objects. Sampling can be done
via three different sampling methods:
}
\details{
\strong{"ugs"} Unconditional gaussian simulation of spatially
cross-correlated errors.

\strong{"randomSampling"} Sampling multivariate distribution using eigenvalue decomposition
(based on 'mvtnorm' package).

\strong{"lhs"} Not implemented yet. Sampling method for at least two uncertain inputs. The
uncertain.object is then a list of two or more. It uses startified sampling
method to generate the inputs for the latin hypercude algorithm, hence number of samples (n)
must be dividable by the number of quantiles to assure each quantile is evenly represented.
}
\examples{

set.seed(12345)
# "ugs" method example
# load data
data(OC, OC_sd, TN, TN_sd)

# Test for SpatialGridDataFrames
OC <- as(OC, 'SpatialGridDataFrame')
TN <- as(TN, 'SpatialGridDataFrame')
OC_sd <- as(OC_sd, 'SpatialGridDataFrame')
TN_sd <- as(TN_sd, 'SpatialGridDataFrame')

# define marginal UMs
OC_crm <- makecrm(acf0 = 0.6, range = 1000, model = "Sph")
OC_UM <- defineUM(TRUE, distribution = "norm", distr_param = c(OC, OC_sd), crm = OC_crm, id = "OC")
TN_crm <- makecrm(acf0 = 0.4, range = 1000, model = "Sph")
TN_UM <- defineUM(TRUE, distribution = "norm", distr_param = c(TN, TN_sd), crm = TN_crm, id = "TN")

# add some dummy third  variable to test code on more than two variables
dummy <- OC
dummy@data <- OC@data*TN@data/2
names(dummy) <- "dummy"
dummy_sd <- dummy
dummy_sd@data <- dummy@data * 0.3
names(dummy_sd) <- "dummy_sd"
dummy_crm <- makecrm(acf0 = 0.9, range = 1000, model = "Sph")
dummy_UM <- defineUM(TRUE, distribution = "norm", distr_param = c(dummy, dummy_sd),
                    crm = dummy_crm, id = "dummy")

# define joint UM
soil_prop <- list(OC_UM, TN_UM)
mySpatialMUM <- defineMUM(soil_prop, matrix(c(1,0.7,0.7,1), nrow=2, ncol=2))
soil_prop <- list(OC_UM, TN_UM, dummy_UM)
mySpatialMUM <- defineMUM(soil_prop, matrix(c(1,0.7,0.2,0.7,1,0.5,0.2,0.5,1), nrow=3, ncol=3))
class(mySpatialMUM)

# sample - "ugs" method
# toy example
my_cross_sample <- genSample(mySpatialMUM, n = 3, "ugs", nmax = 24, asList = TRUE)
class(my_cross_sample)
\dontrun{
my_cross_sample <- genSample(mySpatialMUM, n = 50, "ugs", nmax = 24, asList = TRUE)
class(my_cross_sample)
}



}
\author{
Kasia Sawicka, Stefan van Dam, Gerard Heuvelink
}

