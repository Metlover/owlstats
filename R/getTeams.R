#' Fetch Teams
#'
#' This function grabs a list of active teams tracked by the OWL API.
#' @keywords scraping
#' @return A dataframe with information on OWL teams.
#' @export
#' @examples
#' getTeams()
getTeams = function(){
  teams = jsonlite::fromJSON('https://api.overwatchleague.com/teams',flatten=TRUE)
  teams = teams[["competitors"]]
  teams = teams[,c("competitor.id",
                    "competitor.name",
                    "competitor.homeLocation",
                    "competitor.abbreviatedName",
                    "competitor.addressCountry",
                    "competitor.owl_division",
                    "competitor.attributes.team_guid")]
  names(teams) = c("team_id","team_name","team_location","team_abbrev","team_country","team_division","team_guid")
  teams$team_division = ifelse(teams$team_division == 79,"Atlantic","Pacific")
  return(teams)
}
