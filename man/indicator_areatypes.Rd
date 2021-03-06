% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/area_types.R
\name{indicator_areatypes}
\alias{indicator_areatypes}
\title{Area types by indicator}
\usage{
indicator_areatypes(IndicatorID, AreaTypeID)
}
\arguments{
\item{IndicatorID}{integer; the Indicator ID (can be ignored or of length 1).
Takes priority over AreaTypeID if both are entered}

\item{AreaTypeID}{integer; the Area Type ID (can be ignored or of length 1)}
}
\value{
A data frame of indicator ids and area type ids
}
\description{
Outputs a data frame of indicator ids and the area type ids that exist for
that indicator
}
\examples{
indicator_areatypes()
}
\seealso{
\code{\link{indicators}} for indicator lookups,
  \code{\link{profiles}} for profile lookups and
  \code{\link{deprivation_decile}} for deprivation decile lookups and
  \code{\link{area_types}} for area type lookups and
  \code{\link{category_types}} for category type lookups and
  \code{\link{indicators_unique}} for unique indicatorids and their names

Other lookup functions: \code{\link{area_types}},
  \code{\link{category_types}},
  \code{\link{deprivation_decile}},
  \code{\link{indicator_metadata}},
  \code{\link{indicators_unique}},
  \code{\link{indicators}}, \code{\link{profiles}}
}
