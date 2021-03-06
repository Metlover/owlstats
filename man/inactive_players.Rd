% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{inactive_players}
\alias{inactive_players}
\title{Inactive Players List}
\format{A data frame with player variables such as id, name, and role.}
\usage{
inactive_players
}
\description{
A dataframe with a list of players currently inactive and not available via the OWL API.
The OWL simply deletes players when they leave the league, so players such as xQc cannot be retrieved from the API.
This incomplete list has values for these players available.
}
\keyword{datasets}
