#' Build OWL Stats database
#'
#' This builds a database with relevant OWL API stat information, including teams, maps, schedules, match results, player stats, and hero values.
#' This function takes a very long time to run for initial setup, and it is reccomended that you use the provided 
#' \code{updateDB} function to update an existing database created with this function instead of re-running this function.
#' @param connection A DBI connection object.
#' @keywords scraping, database
#' @export
#' @examples
#' buildDB()
buildDB = function(connection){
  if(lubridate::month(Sys.Date()) <= 1){
    seasons = c(2018:lubridate::year(Sys.Date())-1)
  }
  else{
    seasons = c(2018:lubridate::year(Sys.Date()))
  }
  cat('Scraping teams...\n')
  teams = getTeams()
  cat('Scraping players...\n')
  players = getPlayers()
  cat('Scraping maps...\n')
  maps = getMaps()
  cat('Scraping schedule - be patient, this may take a minute...\n')
  schedule = getSchedule(seasons[1],seasons[-1])
  print('Scraping player stats...\n')
  playerStats = data.frame()
  for(season in seasons){
    playerStats.regSeason = getPlayerStats(season)
    playerStats.postSeason = getPlayerStats(season,TRUE)
    playerStats.regSeason$season.id = paste(season,'REG',sep='-')
    playerStats.postSeason$season.id = paste(season,'POST',sep='-')
    playerStats = rbind(playerStats,playerStats.regSeason)
    playerStats = rbind(playerStats,playerStats.postSeason)
  }
  print('Scraping match results — be patient, this may take a minute...\n')
  matchResults = getMatchResults(schedule$match.id)
  print('Scraping hero values — this will take a while...\n')
  heroVals = getHeroVals(schedule$match.id)
  
  cat('Uploading these files to your database...\n')
  DBI::dbWriteTable(connection, 'teams', teams, row.names=FALSE, overwrite=TRUE)
  DBI::dbWriteTable(connection, 'players',players, row.names=FALSE, overwrite=TRUE)
  DBI::dbWriteTable(connection, 'schedule',schedule, row.names=FALSE, overwrite=TRUE)
  DBI::dbWriteTable(connection, 'players.stats', playerStats, row.names=FALSE, overwrite=TRUE)
  DBI::dbWriteTable(connection, 'matchresults', matchResults, row.names=FALSE, overwrite=TRUE)
  DBI::dbWriteTable(connection, 'herovals', heroVals, row.names=FALSE, overwrite=TRUE)
  gc()
}