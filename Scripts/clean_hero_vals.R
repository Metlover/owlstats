setwd("~/OWL/stats")
temp = list.files(pattern="*.csv")
myfiles = lapply(temp, readr::read_csv)
hero_vals = data.table::rbindlist(myfiles)
slugify <- function(x, alphanum_replace="", space_replace="_", tolower=TRUE) {
  x <- gsub("[^[:alnum:] ]", alphanum_replace, x)
  x <- gsub(" ", space_replace, x)
  if(tolower) { x <- tolower(x) }
  
  return(x)
}
hero_vals$stat_name = slugify(hero_vals$stat_name)
players = owlstats::getPlayers()
teams = owlstats::getTeams()
hero_vals = reshape2::dcast(hero_vals, start_time + match_id + stage + map_type + map_name + player + team + hero ~ stat_name, value.var = 'stat_amount', fun.aggregate = sum)
hero_vals_temp = merge(hero_vals, players[,c('player_name','player_id')], by.x=c('player'),by.y=c('player_name'),all.x=T)
hero_vals_temp = merge(hero_vals_temp, teams[,c('team_name','team_id')], by.x=c('team'),by.y=c('team_name'),all.x=T)
hero_vals = hero_vals_temp
save(hero_vals, file = '~/owlstats-working/owlstats/data/hero_vals.RData')
#save(hero_vals, file = 'data/hero_vals.RData')