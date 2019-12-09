# owlstats
R Package. OWL API Wrapper and associated tools.

## Installation

Use `devtools` to get the latest version.

```
devtools::install_github('Metlover/owlstats')
```

## Use
Currently, the `owlstats` package is designed to be used for scraping. Much of the scraping uses match ids, which can be obtained and used to scrape using the `getSchedule` function. You can also obtain these IDs manually through the [Overwatch League website](https://overwatchleague.com/en-us/schedule).

## Examples

```
#Fetch statistics for San Francisco Shock players by map
library(owlstats)
schedule = getSchedule(2018,2019,team='SFS')
vals = getHeroVals(schedule$match.id)
vals = vals[vals$team == 4404,]
```

## Questions/Suggestions

For any additional features you'd like to see, bugs, or improvements, please [post a new issue](https://github.com/Metlover/owlstats/issues/new).
