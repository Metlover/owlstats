#' Fetch Players
#'
#' This function grabs details about players. It can grab active and some inactive players if specified.
#' @keywords scraping
#' @return A dataframe of player information, such as id, name, and role.
#' @export
#' @examples
#' getPlayers()
#' getPlayers(FALSE)
getPlayers = function(include_inactive=TRUE){
  active_players = jsonlite::fromJSON('https://api.overwatchleague.com/players',flatten = TRUE)
  active_players = active_players[["content"]]
  active_players = unnest(active_players,teams)
  active_players = active_players[,c('id','name','homeLocation','familyName','givenName','nationality','team.id','team.abbreviatedName','attributes.player_number','attributes.role')]
  names(active_players) = c('player.id','player.name','player.home','player.familyName','player.givenName','player.nationality','team.id','team.abbrev','player.number','player.role')
  active_players$player.active = TRUE
  if(include_inactive){
    data("inactive_players", envir=environment())
    return(rbind(active_players,inactive_players))
  }
  else{
    return(active_players)
  }
}
