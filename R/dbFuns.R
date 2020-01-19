#' Build OW Database
#'
#' This function uses the built-in scraping functions in the \code{owlstats} package to build a database of OWL Stats.
#' This function should be run once to build a new database. It should not be run every time you want to update your
#' database; for that, use \code{updateOWDB}.
#' @param connection A DBI connection object.
#' @keywords scraping database
#' @export
#' @examples
#' library(RMySQL)
#' mydb = dbConnect(MySQL(), user='user', password='password', dbname='owl', host='host')
#' buildOWDB(mydb)
buildOWDB = function(connection){
  seasons = c(2018:2019)
  cat('Scraping teams...\n')
  teams = getTeams()
  cat('Scraping players...\n')
  players = getPlayers()
  players$player.active = ifelse(players$player.active, 'TRUE','FALSE') #Convert to string because dbwritetable doesn't handle bool well
  cat('Scraping maps...\n')
  maps = getMaps()
  cat('Scraping schedule - be patient, this may take a minute...\n')
  schedule = getSchedule(seasons[1],seasons[-1])
  cat('Scraping player stats...\n')
  playerStats = data.frame()
  for(season in seasons){
    playerStats.regSeason = getPlayerStats(season)
    playerStats.postSeason = getPlayerStats(season,TRUE)
    playerStats.regSeason$season.id = paste(season,'REG',sep='-')
    playerStats.postSeason$season.id = paste(season,'POST',sep='-')
    playerStats = rbind(playerStats,playerStats.regSeason)
    playerStats = rbind(playerStats,playerStats.postSeason)
  }
  cat('Scraping match results — be patient, this may take a minute...\n')
  matchResults = getMatchResults(schedule$match.id)
  cat('Scraping hero values — this will take a while...\n')
  heroVals = getHeroVals(schedule$match.id)
  
  cat('Uploading these files to your database...\n')
  DBI::dbWriteTable(connection, 'teams', teams, row.names=FALSE, overwrite=TRUE)
  DBI::dbWriteTable(connection, 'players', players, row.names=FALSE, overwrite=TRUE)
  DBI::dbWriteTable(connection, 'maps', maps, row.names=FALSE, overwrite=TRUE)
  DBI::dbWriteTable(connection, 'schedule', schedule, row.names=FALSE, overwrite=TRUE)
  DBI::dbWriteTable(connection, 'playerStats', playerStats, row.names=FALSE, overwrite=TRUE)
  DBI::dbWriteTable(connection, 'matchResults', matchResults, row.names=FALSE, overwrite=TRUE)
  DBI::dbWriteTable(connection, 'heroVals', heroVals, row.names=FALSE, overwrite=TRUE)
  gc()
}

#' Update OW Database
#'
#' This function uses the built-in scraping functions in the \code{owlstats} package to update a previously existing
#' OWL stats database.This function should not be run to build a new database; you should use \code{buildOWDB}.
#' This function overwrites all tables in the database except heroVals and matchResults; for those tables it appends
#' new values.
#' @param connection A DBI connection object.
#' @keywords scraping database
#' @export
#' @examples
#' library(RMySQL)
#' mydb = dbConnect(MySQL(), user='user', password='password', dbname='owl', host='host')
#' updateOWDB(mydb)
updateOWDB = function(connection){
  seasons = c(2018:2019)
  cat('Scraping teams...\n')
  teams = getTeams()
  cat('Scraping players...\n')
  players = getPlayers()
  players$player.active = ifelse(players$player.active, 'TRUE','FALSE') #Convert to string because dbwritetable doesn't handle bool well
  cat('Scraping maps...\n')
  maps = getMaps()
  cat('Scraping schedule - be patient, this may take a minute...\n')
  schedule = getSchedule(seasons[1],seasons[-1])
  cat('Scraping player stats...\n')
  playerStats = data.frame()
  for(season in seasons){
    playerStats.regSeason = getPlayerStats(season)
    playerStats.postSeason = getPlayerStats(season,TRUE)
    playerStats.regSeason$season.id = paste(season,'REG',sep='-')
    playerStats.postSeason$season.id = paste(season,'POST',sep='-')
    playerStats = rbind(playerStats,playerStats.regSeason)
    playerStats = rbind(playerStats,playerStats.postSeason)
  }
  origmatchids = DBI::dbGetQuery(connection, "SELECT distinct(match.id) from schedule")
  unscrapedmatchids = schedule$match.id[!(schedule$match.id %in% origmatchids)]
  cat('Scraping match results — be patient, this may take a minute...\n')
  matchResults = getMatchResults(unscrapedmatchids)
  cat('Scraping hero values — this will take a while...\n')
  heroVals = getHeroVals(unscrapedmatchids)
  
  cat('Uploading these files to your database...\n')
  DBI::dbWriteTable(connection, 'teams', teams, row.names=FALSE, overwrite=TRUE)
  DBI::dbWriteTable(connection, 'players', players, row.names=FALSE, overwrite=TRUE)
  DBI::dbWriteTable(connection, 'maps', maps, row.names=FALSE, overwrite=TRUE)
  DBI::dbWriteTable(connection, 'schedule', schedule, row.names=FALSE, overwrite=TRUE)
  DBI::dbWriteTable(connection, 'playerStats', playerStats, row.names=FALSE, overwrite=TRUE)
  DBI::dbWriteTable(connection, 'matchResults', matchResults, row.names=FALSE, append=TRUE)
  DBI::dbWriteTable(connection, 'heroVals', heroVals, row.names=FALSE, append=TRUE)
  gc()
}
