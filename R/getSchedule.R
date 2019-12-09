#' Fetch Schedule
#'
#' This function gets the OWL schedule for a given season(s), and can fetch the schedule for a given team.
#' Note that due to the limitations of the API, limiting your scrape to a given team will not improve the runtime of this function.
#' @param startYear The first year of the schedule you wish to scrape, like "2018".
#' @param endYear The last year of the schedule you wish to scrape, like "2019".
#' @param team If specified, returns the schedule for a given team, such as "NYE" or "SFS". If unspecified, returns the schedule for all teams in that time frame.
#' @keywords scraping
#' @return A dataframe containing the schedule, match.ids, and results for the seasons and teams specified.
#' @export
#' @examples
#' getSchedule(2018,2018)
#' getSchedule(2018,2019,team="NYE")
getSchedule = function(startYear, endYear, team="All"){
  `%>%` <- magrittr::`%>%`
  mainschedule = data.frame()
  for(year in c(startYear:endYear)){
    schedule = jsonlite::fromJSON(paste('https://api.overwatchleague.com/schedule?expand=team.content&locale=en_US&season=',year,sep=''))
    if(schedule[["data"]][["id"]] != year){
      stop("Attemtped to scrape matchIds for a season that does not exist.
           Ensure your season IDs are correct and try again.")
    }
    scheduletemp = data.frame()
    for(n in 1:length(schedule[["data"]][["stages"]][["matches"]])){ #This looks ugly, but it isn't, it's pretty short to iterate through
      if(length(schedule[["data"]][["stages"]][["matches"]][[n]]) != 0){
        stage = schedule[["data"]][["stages"]][["matches"]][[n]]
        stage = stage[,c('id',
                         'competitors',
                         'state',
                         'status',
                         'wins',
                         'statusReason',
                         'startDate',
                         'endDate')]
        stage$stage.name = schedule[["data"]][["stages"]][["matches"]][[n]][["bracket"]][["stage"]][["tournament"]][["title"]]
        stage$stage.id = schedule[["data"]][["stages"]][["matches"]][[n]][["bracket"]][["stage"]][["tournament"]][["id"]]
        scheduletemp = rbind(scheduletemp,stage)
      }
    }
    names(scheduletemp)[1] = 'match.id'
    scheduletemp = tidyr::unnest_wider(scheduletemp,competitors)
    scheduletemp$teama.id = sapply(scheduletemp$id,'[',1)
    scheduletemp$teamb.id = sapply(scheduletemp$id,'[',2)
    scheduletemp$teama.abbrev = sapply(scheduletemp$abbreviatedName,'[',1)
    scheduletemp$teamb.abbrev = sapply(scheduletemp$abbreviatedName,'[',2)
    scheduletemp$teama.score = sapply(scheduletemp$wins,'[',1)
    scheduletemp$teamb.score = sapply(scheduletemp$wins,'[',2)
    scheduletemp$winner.id = ifelse(scheduletemp$teama.score == scheduletemp$teamb.score, 0, ifelse(scheduletemp$teama.score > scheduletemp$teamb.score, scheduletemp$teama.id, scheduletemp$teamb.id))
    scheduletemp$winner.abbrev = ifelse(scheduletemp$teama.score == scheduletemp$teamb.score, 'DRW', ifelse(scheduletemp$teama.score > scheduletemp$teamb.score, scheduletemp$teama.abbrev, scheduletemp$teamb.abbrev))
    scheduletemp$date = as.POSIXct(scheduletemp$startDate)
    mainschedule = rbind(mainschedule,scheduletemp[,c('match.id','state','date','stage.name','stage.id','teama.id','teamb.id','teama.abbrev','teamb.abbrev','teama.score','teamb.score','winner.id','winner.abbrev')])
  }
  names(mainschedule) = c('match.id','match.state','match.date','stage.name','stage.id','match.teama.id','match.teamb.id','match.teama.abbrev','match.teamb.abbrev','match.teama.score','match.teamb.score','match.winner.id','match.winner.abbrev')
  if(team == "All"){
    return(as.data.frame(mainschedule))
  }
  else{
    return(as.data.frame(mainschedule %>%
             dplyr::filter(match.teama.abbrev == team | match.teamb.abbrev == team)))
  }
}
