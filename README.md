# owlstats
R Package. Originally an OWL API Wrapper, but that functionality has been scrapped in order to allow access to more advanced statistics through the OWL Statslab.

## Installation

Use `devtools` to get the latest version.

```
devtools::install_github('Metlover/owlstats')
```

## Use

Originally written as a scraping package, the advent of bulk csv downloads of more advanced data through the OWL Statslab allowed a faster workload and functionality with better data. For this purpose, I have downloaded and updated previous season's Statslab datasets.

## Examples

```
#Fetch statistics for San Francisco Shock players by map
hero_vals = owlstats::hero_vals[hero_vals$team_id == 4404,]

#Create a MySQL database with OWL API Stats
library(RMySQL)
mydb = dbConnect(MySQL(), user='user',password='password',dbname='owl',host='host)
buildOWDB(mydb)
```

## Questions/Suggestions

For any additional features you'd like to see, bugs, or improvements, please [post a new issue](https://github.com/Metlover/owlstats/issues/new).
