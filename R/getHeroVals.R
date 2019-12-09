#' Fetch Hero Values
#'
#' This function grabs cumulative player stats, split by map, for matches included in match.ids.
#' These values are the total stats - like eliminations, deaths, and damage - accumulated over the course of a map and are not prorated to any time interval.
#' An ambigious time_played column is included but the relationship between the value from the API and the actual time of the map is murky.
#' Heroes played and stats per hero are available through the API but are not scraped by this function. There is no breakdown of time played on each hero, rendering the statistics included effectively useless.
#' @param match.ids A list of match.ids, like those returned by \code{getSchedule()}.
#' @keywords scraping
#' @return A dataframe of cumulative statistics for the match.ids specified, split by match, map, and player.
#' @export
#' @examples
#' getHeroVals(21515)
#' getHeroVals(c(21485, 21494, 21521, 21419, 21514, 21446, 21515))
getHeroVals = function(match.ids){
  hero_values = data.frame()
  total = length(match.ids)
  pb = txtProgressBar(min = 0, max = total, style = 3)
  for(match.id in match.ids){
    for(n in 1:8){
      tryCatch({
        map = jsonlite::fromJSON(paste('https://api.overwatchleague.com/stats/matches/',match.id,'/maps/',n))
        df = data.frame(match.id = map[["esports_match_id"]])
        df$season.id = map[["season_id"]]
        df$map.no = map[["game_number"]]
        df$map.type = map[["map_type"]]
        df$map.guid = map[["map_id"]]
        df$tournament.id = map[["esports_tournament_id"]]
        df$match.id = map[["esports_match_id"]]
        for(team in 1:2){
          df$team = map[["teams"]][["esports_team_id"]][team]
          for(player in 1:nrow(map[["teams"]][["players"]][[team]])){
            df$player.id = map[["teams"]][["players"]][[team]][["esports_player_id"]][player]
            df$player.damage = ifelse(length(map[["teams"]][["players"]][[team]][["stats"]][[player]][["value"]][map[["teams"]][["players"]][[team]][["stats"]][[player]][["name"]] == "damage"]) == 0, 0, map[["teams"]][["players"]][[team]][["stats"]][[player]][["value"]][map[["teams"]][["players"]][[team]][["stats"]][[player]][["name"]] == "damage"])
            df$player.deaths = ifelse(length(map[["teams"]][["players"]][[team]][["stats"]][[player]][["value"]][map[["teams"]][["players"]][[team]][["stats"]][[player]][["name"]] == "deaths"]) == 0, 0, map[["teams"]][["players"]][[team]][["stats"]][[player]][["value"]][map[["teams"]][["players"]][[team]][["stats"]][[player]][["name"]] == "deaths"])
            df$player.eliminations = ifelse(length(map[["teams"]][["players"]][[team]][["stats"]][[player]][["value"]][map[["teams"]][["players"]][[team]][["stats"]][[player]][["name"]] == "eliminations"]) == 0, 0, map[["teams"]][["players"]][[team]][["stats"]][[player]][["value"]][map[["teams"]][["players"]][[team]][["stats"]][[player]][["name"]] == "eliminations"])
            df$player.healing = ifelse(length(map[["teams"]][["players"]][[team]][["stats"]][[player]][["value"]][map[["teams"]][["players"]][[team]][["stats"]][[player]][["name"]] == "healing"]) == 0, 0, map[["teams"]][["players"]][[team]][["stats"]][[player]][["value"]][map[["teams"]][["players"]][[team]][["stats"]][[player]][["name"]] == "healing"])
            df$player.time_played = map[["stats"]][["value"]]
            hero_values = rbind(hero_values,df)
          }
        }
      },error=function(e){})
    }
    i = which(match.ids == match.id)
    setTxtProgressBar(pb, i)
  }
  close(pb)
  return(hero_values)
}
