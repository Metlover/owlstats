#' Fetch Standings
#'
#' This function pulls the standings for a given stage or seasons from the OWL API.
#' If no stage is specified, pulls for the given season. If a stage is specified, pulls standings for just that stage.
#' @param season SeasonID, usually the year of a given season, i.e. "2019".
#' @param stage.no The number of an OWL stage. Defaults to NA.
#' @keywords scraping
#' @return A dataframe representing the standings of a given OWL season or stage. Includes match wins/losses and map wins/losses/ties.
#' @export
#' @examples
#' getStandings(2018)
#' getStandings(2019,3)
getStandings = function(season,stage.no=NA){
  standings = jsonlite::fromJSON(paste('https://api.overwatchleague.com/v2/standings?season=',season,sep=''),)
  standings = jsonlite::flatten(standings[["data"]])
  if(is.na(stage.no)){
    standings = standings[,c('id',
                            'divisionId',
                            'abbreviatedName',
                            'league.matchWin',
                            'league.matchLoss',
                            'league.matchDraw',
                            'league.gameWin',
                            'league.gameLoss',
                            'league.gameTie',
                            'league.placement')]
    names(standings) = c('team_id','team_division','team_abbrev','team_match_wins','team_match_losses','team_match_draws','team_game_wins','team_game_losses','team_game_ties','team_placement')
  }
  else{
    standings = standings[,c('id',
                             'divisionId',
                             'abbreviatedName',
                             paste('stages.stage',stage.no,'.matchWin',sep=''),
                             paste('stages.stage',stage.no,'.matchLoss',sep=''),
                             paste('stages.stage',stage.no,'.matchDraw',sep=''),
                             paste('stages.stage',stage.no,'.gameWin',sep=''),
                             paste('stages.stage',stage.no,'.gameLoss',sep=''),
                             paste('stages.stage',stage.no,'.gameTie',sep=''),
                             paste('stages.stage',stage.no,'.placement',sep=''))]
    names(standings) = c('team_id','team_division','team_abbrev','team_match_wins','team_match_losses','team_match_draws','team_game_wins','team_game_losses','team_game_ties','team_placement')
  }
  standings$team_division = ifelse(standings$team_division == 79,"Atlantic","Pacific")
  standings = standings[order(standings$team_placement),]
  return(standings)
}
