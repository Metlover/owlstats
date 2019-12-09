#' Fetch Match Results
#'
#' This function grabs the match results for a given list of match ids, and returns the information as a dataframe.
#' Included is match information, such as teams playing, match status, match score, and individual map scores and types.
#' Note that the number of possible maps included goes up to eight to ensure that no information is lost from playoff matches.
#' @param match.ids A list of match.ids, like those fetched by \code{getSchedule()}.
#' @keywords scraping
#' @return A dataframe representing the match results for all the match.ids passed in.
#' @export
#' @examples
#' getMatchResults(21515)
#' getMatchResults(c(21485, 21494, 21521, 21419, 21514, 21446, 21515))
getMatchResults = function(match.ids){
  match_results = data.frame()
  maps = getMaps()
  total = length(match.ids)
  pb = txtProgressBar(min = 0, max = total, style = 3)
  for(match.id in match.ids){
    df = data.frame(id=match.id)
    tryCatch({
      game = jsonlite::fromJSON(paste('https://api.overwatchleague.com/match/',match.id,sep=''),flatten = TRUE)
      df$stage.id = game[["bracket"]][["stage"]][["tournament"]][["id"]]
      df$match.start_time = as.POSIXct( game[["startDate"]][1]/1000.0, origin="1970-01-01")
      df$match.status = game[["state"]]
      df$match.teama.id =  game[["competitors"]][["id"]][1]
      df$match.teama.abbrev = game[["competitors"]][["abbreviatedName"]][1]
      df$match.teamb.id =  game[["competitors"]][["id"]][2]
      df$match.teamb.abbrev = game[["competitors"]][["abbreviatedName"]][2]
      df$match.teama.score = game[["scores"]][["value"]][1]
      df$match.teamb.score = game[["scores"]][["value"]][2]
      df$match.games = ifelse(is.null(game[["games"]][["attributes.mapScore.team1"]]),game[["conclusionValue"]],sum(sapply(X = game[["games"]][["attributes.mapScore.team1"]], FUN = function(x) sum(!is.na(x)))))
      df$match.winner = ifelse(game[["scores"]][["value"]][1] > game[["scores"]][["value"]][2], game[["competitors"]][["id"]][1], ifelse(game[["scores"]][["value"]][2] > game[["scores"]][["value"]][1],game[["competitors"]][["id"]][2],NA))
      df$match.conclusionstrat = game[["conclusionStrategy"]]
      df$match.tournament.id = game[["bracket"]][["stage"]][["tournament"]][["id"]]
      df$match.map1.id = ifelse(length(game[["games"]][["points"]])>=1,game[["games"]][["id"]][1],NA)
      df$match.map1.num = ifelse(length(game[["games"]][["points"]])>=1,1,NA)
      df$match.map1.name = ifelse(is.null(game[["games"]][["attributes.map"]][1]) || is.na(game[["games"]][["attributes.map"]][1]),ifelse(is.null(game[["games"]][["attributes.mapGuid"]][1]),NA,maps$map.slug[which(game[["games"]][["attributes.mapGuid"]][1]==maps$map.guid)]),game[["games"]][["attributes.map"]][1])
      df$match.map1.teama.score = ifelse(length(game[["games"]][["points"]])>=1,ifelse(game[["state"]] == 'CONCLUDED', game[["games"]][["attributes.mapScore.team1"]][1],NA),NA)
      df$match.map1.teamb.score = ifelse(length(game[["games"]][["points"]])>=1,ifelse(game[["state"]] == 'CONCLUDED', game[["games"]][["attributes.mapScore.team2"]][1],NA),NA)
      df$match.map1.type = maps$type[maps$map.slug == df$map_1_name][1]
      df$match.map2.id = ifelse(length(game[["games"]][["points"]])>=2,game[["games"]][["id"]][2],NA)
      df$match.map2.num = ifelse(length(game[["games"]][["points"]])>=2,2,NA)
      df$match.map2.name = ifelse(is.null(game[["games"]][["attributes.map"]][2]) || is.na(game[["games"]][["attributes.map"]][2]),ifelse(is.null(game[["games"]][["attributes.mapGuid"]][2]),NA,maps$map.slug[which(game[["games"]][["attributes.mapGuid"]][2]==maps$map.guid)]),game[["games"]][["attributes.map"]][2])
      df$match.map2.teama.score = ifelse(length(game[["games"]][["points"]])>=2,ifelse(game[["state"]] == 'CONCLUDED', game[["games"]][["attributes.mapScore.team1"]][2],NA),NA)
      df$match.map2.teamb.score = ifelse(length(game[["games"]][["points"]])>=2,ifelse(game[["state"]] == 'CONCLUDED', game[["games"]][["attributes.mapScore.team2"]][2],NA),NA)
      df$match.map2.type = maps$type[maps$map.slug == df$map_2_name][1]
      df$match.map3.id = ifelse(length(game[["games"]][["points"]])>=3,game[["games"]][["id"]][3],NA)
      df$match.map3.num = ifelse(length(game[["games"]][["points"]])>=3,3,NA)
      df$match.map3.name = ifelse(is.null(game[["games"]][["attributes.map"]][3]) || is.na(game[["games"]][["attributes.map"]][3]),ifelse(is.null(game[["games"]][["attributes.mapGuid"]][3]),NA,maps$map.slug[which(game[["games"]][["attributes.mapGuid"]][3]==maps$map.guid)]),game[["games"]][["attributes.map"]][3])
      df$match.map3.teama.score = ifelse(length(game[["games"]][["points"]])>=3,ifelse(game[["state"]] == 'CONCLUDED', game[["games"]][["attributes.mapScore.team1"]][3],NA),NA)
      df$match.map3.teamb.score = ifelse(length(game[["games"]][["points"]])>=3,ifelse(game[["state"]] == 'CONCLUDED', game[["games"]][["attributes.mapScore.team2"]][3],NA),NA)
      df$match.map3.type = maps$type[maps$map.slug == df$map_3_name][1]
      df$match.map4.id = ifelse(length(game[["games"]][["points"]])>=4,game[["games"]][["id"]][4],NA)
      df$match.map4.num = ifelse(length(game[["games"]][["points"]])>=4,4,NA)
      df$match.map4.name = ifelse(is.null(game[["games"]][["attributes.map"]][4]) || is.na(game[["games"]][["attributes.map"]][4]),ifelse(is.null(game[["games"]][["attributes.mapGuid"]][4]),NA,maps$map.slug[which(game[["games"]][["attributes.mapGuid"]][4]==maps$map.guid)]),game[["games"]][["attributes.map"]][4])
      df$match.map4.teama.score = ifelse(length(game[["games"]][["points"]])>=4,ifelse(game[["state"]] == 'CONCLUDED', game[["games"]][["attributes.mapScore.team1"]][4],NA),NA)
      df$match.map4.teamb.score = ifelse(length(game[["games"]][["points"]])>=4,ifelse(game[["state"]] == 'CONCLUDED', game[["games"]][["attributes.mapScore.team2"]][4],NA),NA)
      df$match.map4.type = maps$type[maps$map.slug == df$map_4_name][1]
      df$match.map5.id = ifelse(length(game[["games"]][["points"]])>=5,game[["games"]][["id"]][5],NA)
      df$match.map5.num = ifelse(length(game[["games"]][["points"]])>=5,5,NA)
      df$match.map5.name = ifelse(is.null(game[["games"]][["attributes.map"]][5]) || is.na(game[["games"]][["attributes.map"]][5]),ifelse(is.null(game[["games"]][["attributes.mapGuid"]][5]),NA,maps$map.slug[which(game[["games"]][["attributes.mapGuid"]][5]==maps$map.guid)]),game[["games"]][["attributes.map"]][5])
      df$match.map5.teama.score = ifelse(length(game[["games"]][["points"]])>=5,ifelse(game[["state"]] == 'CONCLUDED', game[["games"]][["attributes.mapScore.team1"]][5],NA),NA)
      df$match.map5.teamb.score = ifelse(length(game[["games"]][["points"]])>=5,ifelse(game[["state"]] == 'CONCLUDED', game[["games"]][["attributes.mapScore.team2"]][5],NA),NA)
      df$match.map5.type = maps$type[maps$map.slug == df$map_5_name][1]
      df$match.map6.id = ifelse(length(game[["games"]][["points"]])>=6,game[["games"]][["id"]][6],NA)
      df$match.map6.num = ifelse(length(game[["games"]][["points"]])>=6,6,NA)
      df$match.map6.name = ifelse(is.null(game[["games"]][["attributes.map"]][6]) || is.na(game[["games"]][["attributes.map"]][6]),ifelse(is.null(game[["games"]][["attributes.mapGuid"]][6]),NA,maps$map.slug[which(game[["games"]][["attributes.mapGuid"]][6]==maps$map.guid)]),game[["games"]][["attributes.map"]][6])
      df$match.map6.teama.score = ifelse(length(game[["games"]][["points"]])>=6,ifelse(game[["state"]] == 'CONCLUDED', game[["games"]][["attributes.mapScore.team1"]][6],NA),NA)
      df$match.map6.teamb.score = ifelse(length(game[["games"]][["points"]])>=6,ifelse(game[["state"]] == 'CONCLUDED', game[["games"]][["attributes.mapScore.team2"]][6],NA),NA)
      df$match.map6.type = maps$type[maps$map.slug == df$map_6_name][1]
      df$match.map7.id = ifelse(length(game[["games"]][["points"]])>=7,game[["games"]][["id"]][7],NA)
      df$match.map7.num = ifelse(length(game[["games"]][["points"]])>=7,7,NA)
      df$match.map7name = ifelse(is.null(game[["games"]][["attributes.map"]][7]) || is.na(game[["games"]][["attributes.map"]][7]),ifelse(is.null(game[["games"]][["attributes.mapGuid"]][7]),NA,maps$map.slug[which(game[["games"]][["attributes.mapGuid"]][7]==maps$map.guid)]),game[["games"]][["attributes.map"]][7])
      df$match.map7.teama.score = ifelse(length(game[["games"]][["points"]])>=7,ifelse(game[["state"]] == 'CONCLUDED', game[["games"]][["attributes.mapScore.team1"]][7],NA),NA)
      df$match.map7.teamb.score = ifelse(length(game[["games"]][["points"]])>=7,ifelse(game[["state"]] == 'CONCLUDED', game[["games"]][["attributes.mapScore.team2"]][7],NA),NA)
      df$match.map7.type = maps$type[maps$map.slug == df$map_7_name][1]
      df$match.map8.id = ifelse(length(game[["games"]][["points"]])>=8,game[["games"]][["id"]][8],NA)
      df$match.map8.num = ifelse(length(game[["games"]][["points"]])>=8,8,NA)
      df$match.map8.name = ifelse(is.null(game[["games"]][["attributes.map"]][8]) || is.na(game[["games"]][["attributes.map"]][8]),ifelse(is.null(game[["games"]][["attributes.mapGuid"]][8]),NA,maps$map.slug[which(game[["games"]][["attributes.mapGuid"]][8]==maps$map.guid)]),game[["games"]][["attributes.map"]][8])
      df$match.map8.teama.score = ifelse(length(game[["games"]][["points"]])>=8,ifelse(game[["state"]] == 'CONCLUDED', game[["games"]][["attributes.mapScore.team1"]][8],NA),NA)
      df$match.map8.teamb.score = ifelse(length(game[["games"]][["points"]])>=8,ifelse(game[["state"]] == 'CONCLUDED', game[["games"]][["attributes.mapScore.team2"]][8],NA),NA)
      df$match.map8.type = maps$type[maps$map.slug == df$map_8_name][1]
      match_results = rbind(match_results,df)
    },error=function(e){
      print(e)
    })
    i = which(match.ids == match.id)
    setTxtProgressBar(pb, i)
  }
  close(pb)
  return(match_results)
}

#' Fetch Maps
#'
#' A helper function that pulls the details for all maps trakced by the OWL API.
#' @keywords scraping helper
#' @return A dataframe with details on every map tracked by the OWL API.
#' @export
#' @examples
#' getMaps()
getMaps = function(){
  maps = jsonlite::fromJSON('https://api.overwatchleague.com/maps',flatten=TRUE)
  maps = as.data.frame(tidyr::unnest(maps, cols=c(gameModes))) #nested lists for different game modes
  maps = maps[,c('guid','Name','id','type','name.en_US')]
  names(maps) = c('map.guid','map.gamemode','map.slug','map.type','map.name')
  maps = maps[c('map.name','map.type','map.gamemode','map.slug','map.guid')]
  return(maps)
}
