# Covid Tracker

This is a Rails app that generates graphs tracking COVID-19 in registered regions.  The graphs generated include the following based on data from  - the last 7 days, the last 30 days.  Coming soon, it will also include all data since March 2020.
 
* cumulative confirmed cases 
* daily change in confirmed cases
* cumulative confirmed deaths
* daily change in confirmed deaths

## Prerequisites:

* ruby 2.5
* rails 5.2
* imagemagick - used for graph generation

## Registering Regions

Create or edit `/config/initializers/covid_regions.rb` and register each region for which you would like to see a graph.

### Examples:

```
# Register regions in the United States
CovidTracker::RegionRegistry.register_usa # generate graphs from all US data
CovidTracker::RegionRegistry.register_usa(state: 'Georgia') # generate graphs for the specific state
CovidTracker::RegionRegistry.register_usa(state: 'New York', county: 'Tompkins') # generate graphs for the specified county

# Register regions outside the United States
CovidTracker::RegionRegistry.register(country_iso: 'DEU', province_state: 'Berlin') # generate graphs for the specific province
CovidTracker::RegionRegistry.register(country_iso: 'CHN') # generate graphs for the specified country
```

List of country ISO codes: https://covid-api.com/api/regions

List of US state names: https://covid-api.com/api/provinces/usa

List of country province names (substitute country's ISO code for `:iso`): https://covid-api.com/api/provinces/:iso 

## Generate graphs

```
$ bundle exec rails c
>> CovidTracker::GraphingService.update_all_graphs(days: 7)
>> CovidTracker::GraphingService.update_all_graphs(days: 30)
```

This fetches the data for each day.  Eventually, the data will be cached in a local database to make data extraction performant.  At this time, it is not recommended generating graphs for all data since March 2020 as it will not perform well and could crash due to the quantity of data.

At this time, the graphs are stored in /public/covid_tracker/charts.  The graphs have to be manually copied into the Jekyll site.  They also have to be renamed to the names expected in the pages in the Jekyll site.  The plan is to generate them directly into the Jekyll site.

## Acknowlegements

Data from: 
[COVID-19 Data Repository by the Center for Systems Science and Engineering (CSSE) at Johns Hopkins University](https://github.com/CSSEGISandData/COVID-19) 
(Terms of Use - scroll to bottom)

The API to access the data is 
[COVID API](https://documenter.getpostman.com/view/10724784/SzYXWz3x?version=latest#8b133941-d8b3-4055-8047-46171581cac4)

The mechanism used in the app to access the API is a custom module written to work with the
[Questioning Authority](https://github.com/samvera/questioning_authority) from the [Samvera Community](https://samvera.org). 
