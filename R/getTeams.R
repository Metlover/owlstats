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
  teams = teams[ ,c("competitor.id",
                    "competitor.name",
                    "competitor.homeLocation",
                    "competitor.abbreviatedName",
                    "competitor.addressCountry",
                    "competitor.owl_division",
                    "competitor.attributes.team_guid")] #neither do these
  names(teams) = c("team.id","team.name","team.location","team.abbrev","team.country","team.division","team.guid")
  teams$Division = ifelse(teams$Division == 79,"Atlantic","Pacific")
  return(teams)
}
