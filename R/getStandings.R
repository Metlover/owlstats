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
    names(standings) = c('team.id','team.division','team.abbrev','team.match.wins','team.match.losses','team.match.draws','team.game.wins','team.game.losses','team.game.ties','team.placement')
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
    names(standings) = c('team.id','team.division','team.abbrev','team.match.wins','team.match.losses','team.match.draws','team.game.wins','team.game.losses','team.game.ties','team.placement')
  }
  standings$team.division = ifelse(standings$team.division == 79,"Atlantic","Pacific")
  standings = standings[order(standings$team.placement),]
  return(standings)
}
