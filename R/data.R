#' Inactive Players List
#' 
#' A dataframe with a list of players currently inactive and not available via the OWL API.
#' The OWL simply deletes players when they leave the league, so players such as xQc cannot be retrieved from the API.
#' This incomplete list has values for these players available. 
#' 
#' @format A data frame with player variables such as id, name, and role.
#'
"inactive_players"