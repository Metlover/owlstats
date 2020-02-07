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
  active_players = tidyr::unnest(active_players,teams)
  active_players = active_players[,c('id','name','homeLocation','familyName','givenName','nationality','team.id','team.abbreviatedName','attributes.player_number','attributes.role')]
  names(active_players) = c('player_id','player_name','player_home','player_familyName','player_givenName','player_nationality','team_id','team_abbrev','player_number','player_role')
  active_players$player_active = TRUE
  active_players$player_name[active_players$player_name == 'blas'] = 'blasé'
  if(include_inactive){
    data("inactive_players", envir=environment())
    return(as.data.frame(rbind(active_players,inactive_players)))
  }
  else{
    return(as.data.frame(active_players))
  }
}
