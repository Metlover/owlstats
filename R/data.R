#' Inactive Players List
#' 
#' A dataframe with a list of players currently inactive and not available via the OWL API.
#' The OWL simply deletes players when they leave the league, so players such as xQc cannot be retrieved from the API.
#' This incomplete list has values for these players available. 
#' 
#' @format A data frame with player variables such as id, name, and role.
#'
"inactive_players"

#' Hero Vals
#' 
#' A dataframe of all player stats, grouped by map and hero. 
#' Includes hero specific stats, such as Rip-Tire Kills.
#' Data is wide-formatted.
#' 
#' @format A data frame with hero variables for different players on different maps.
#'
"hero_vals"

#' Match Map Stats
#' 
#' A dataframe of the results of each map. Includes stats like completion percentage for control point maps.
#' 
#' @format A data frame with team results for each map.
#'
"match_map_stats"