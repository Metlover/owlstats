#' Fetch Player Stats
#'
#' This function grabs player stats for a given season per ten minutes.
#' These values are across the entire season and are not tracked on a per-game basis, nor are they split by hero.
#' @param season SeasonID, usually the year of a given season, i.e. "2019".
#' @param postseason If true, returns postseason statistics instead of regular season statistics. Defaults to false.
#' @keywords scraping
#' @return A dataframe representing the match results for all the match.ids passed in.
#' @export
#' @examples
#' getPlayerStats(2018)
#' getPlayerStats(2019,TRUE)
getPlayerStats = function(season,postseason=FALSE){
  if(postseason){
    player_stats = jsonlite::fromJSON(paste('https://api.overwatchleague.com/stats/players?stage=postseason&season=',season,sep=''))
  }
  else{
    player_stats = jsonlite::fromJSON(paste('https://api.overwatchleague.com/stats/players?stage=regular_season&season=',season,sep=''))
  }
  player_stats = player_stats[["data"]]
  names(player_stats) = c('player.id','team.id','player.role','player.name','team.abbrev','player.epd','player.depd','player.hdpd','player.hpd','player.upd','player.fpd','player.playtime')
  player_stats = player_stats[,c('player.id','player.name','player.role','team.id','team.abbrev','player.epd','player.depd','player.hdpd','player.hpd','player.upd','player.fpd','player.playtime')]
  return(player_stats)
}
