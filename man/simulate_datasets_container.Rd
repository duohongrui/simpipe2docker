% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/simulate_datasets_container.R
\name{simulate_datasets_container}
\alias{simulate_datasets_container}
\title{Simulate scRNA-seq Datasets}
\usage{
simulate_datasets_container(
  method = NULL,
  parameters = NULL,
  ref_data = NULL,
  other_prior = NULL,
  n = 1,
  seed = simutils::random_seed(),
  return_format = "SingleCellExperiment",
  verbose = TRUE
)
}
\arguments{
\item{method}{A character or a string of methods or NULL. It can be \code{all}
as all methods are used to estimate paramters from real data. If NULL, the
argument \code{parameters} must be generated by \code{\link[simpipe:estimate_parameters]{simpipe::estimate_parameters()}}.}

\item{parameters}{NULL or the object generated by \code{\link[simpipe:estimate_parameters]{simpipe::estimate_parameters()}}.
If NULL, you must input the argument \code{method} above and the default
parameters will be used to perform the simulation step.}

\item{ref_data}{A matrix for one dataset or a list of datasets with their own
names. This is usually unused except for some methods, e.g. SCRIP.}

\item{other_prior}{A list with names of certain parameters. Some methods need
extra parameters to execute the estimation step, so you must input them. In
simulation step, the number of cells, genes, groups, batches, the percent of
DEGs and other variables are usually customed, so before simulating a dataset
you must point it out.}

\item{n}{The time(s) that users want to perform the simulation step with every
method.}

\item{seed}{A random seed. An integer or a vector of integers. If you want to
simulate twice or more times by every method you have chosen, it should be a
vector. If you do not input this parameter, the default value(s) will be used.}

\item{return_format}{A character. Alternatives choices: list, SingleCellExperiment,
Seurat and h5ad.}

\item{verbose}{Logical. Whether to return messages or not.}
}
\description{
This is the core function of simulating scRNA-seq datasets via establishing Docker containers.
}
