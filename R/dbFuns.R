options(encoding = "UTF-8")
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
  cat('Scraping teams...\n')
  teams = getTeams()
  cat('Scraping players...\n')
  players = getPlayers()
  players$player_active = ifelse(players$player_active, 'TRUE','FALSE') #Convert to string because dbwritetable doesn't handle bool well
  cat('Fetching player stats...\n')
  data("hero_vals", envir=environment())
  cat('Fetching map results...\n')
  data("match_map_stats", envir=environment())
  cat('Uploading these files to your database...\n')
  DBI::dbWriteTable(connection, 'teams', teams, row.names=FALSE, overwrite=TRUE)
  DBI::dbWriteTable(connection, 'players', players, row.names=FALSE, overwrite=TRUE)
  DBI::dbWriteTable(connection, 'hero_vals', hero_vals, row.names=FALSE, overwrite=TRUE)
  DBI::dbWriteTable(connection, 'match_map_stats', match_map_stats, row.names=FALSE, overwrite=TRUE)
  gc()
}
