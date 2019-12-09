# owlstats
R Package. OWL API Wrapper and associated tools.

## Installation

Use `devtools` to get the latest version.

```
devtools::install_github('Metlover/owlstats')
```

## Use
Currently, the `owlstats` package is designed to be used for scraping. Much of the scraping uses match ids, which can be obtained and used to scrape using the `getSchedule` function. You can also obtain these IDs manually through the [Overwatch League website](https://overwatchleague.com/en-us/schedule).

There are also two automated functions that put scraped values into SQL databases:

`buildOWDB` creates a database and populates it with the data available in the scraper function. It currently takes about 30-45 minutes to run.

`updateOWDB` updates a database already created with `updateOWDB` by populating the `heroVals` and `matchResults` tables with values not already included in the database.

## Examples

```
#Fetch statistics for San Francisco Shock players by map
library(owlstats)
schedule = getSchedule(2018,2019,team='SFS')
vals = getHeroVals(schedule$match.id)
vals = vals[vals$team == 4404,]

#Create a MySQL database with OWL API Stats
library(RMySQL)
mydb = dbConnect(MySQL(), user='user',password='password',dbname='owl',host='host)
buildOWDB(mydb)
```

## Questions/Suggestions

For any additional features you'd like to see, bugs, or improvements, please [post a new issue](https://github.com/Metlover/owlstats/issues/new).
