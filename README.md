# Covid Tracker

This is a Rails app that generates graphs tracking COVID-19 in registered regions.  The graphs generated include the following based on data from  - the last 7 days, the last 30 days, and all data since March 2020.
 
* daily change in confirmed cases
* daily change in confirmed deaths

It also generates graphs with weekly totals for each region.

## Prerequisites:

* ruby 2.7
* rails 5.2
* imagemagick - used for graph generation

## Registering Regions

Create or edit `/config/initializers/covid_regions.rb` and register each area and regions in the area for which you would like to see graphs.  Typically, the central area is the primary area of interest and the regions are other regions that are close to the primary area of interest (e.g. the county where you live and all counties adjacent to it).

### Examples:

```
# Registering regions in a central area
CovidTracker::CentralAreaRegistry.register_usa(state: 'New York', county: 'Cortland',
                                               sidebar_label: "Cortland County, NY Area",
                                               homepage_title: "Cortland County, NY and Surrounding Counties") do
  [
    CovidTracker::RegionRegistration.for_usa(state: 'New York', county: 'Cortland'),
    CovidTracker::RegionRegistration.for_usa(state: 'New York', county: 'Tompkins'),
    CovidTracker::RegionRegistration.for_usa(state: 'New York', county: 'Broome'),
    CovidTracker::RegionRegistration.for_usa(state: 'New York', county: 'Onondaga'),
    CovidTracker::RegionRegistration.for_usa(state: 'New York', county: 'Cayuga'),
    CovidTracker::RegionRegistration.for_usa(state: 'New York', county: 'Madison'),
    CovidTracker::RegionRegistration.for_usa(state: 'New York', county: 'Chenango'),
    CovidTracker::RegionRegistration.for_usa(state: 'New York', county: 'Tioga')
  ]
end
```

NOTE: That the list of regions include the central area as a region.

List of country ISO codes: https://covid-api.com/api/regions

List of US state names: https://covid-api.com/api/provinces/usa

List of country province names (substitute country's ISO code for `:iso`): https://covid-api.com/api/provinces/:iso 

You can define regions as US counties as seen above.  You can also define regions at the state level, at the country level, or at the province level for other countries.

```
    CovidTracker::RegionRegistration.for_usa(state: 'New York')
    CovidTracker::RegionRegistration.for(country_iso: 'DEU')
    CovidTracker::RegionRegistration.for(country_iso: 'DEU', province_state: 'Berlin')
```

## Configuring the Jekyll theme for the area site

Edit `/docs/_config.xml` and update the configs in Section of COMMON configs to change.  Configs you may want to change are at the top of the file and include comments stating how they are used in the site.

## Generate graphs

```
$ _RAILS_ROOT_/bin/update_site -s -p -g
```

-s generates the sidebar menu in to `/docs/_data/sidebars` <br />
-p generates the pages showing the graphs in to `/docs/pages` <br />
-g generates the graphs in to `/docs/images/graphs` <br />
-t generates the requested data with paths that work for local testing using `jekyll server` <br />
     DO NOT include the -t parameter when generating data to deploy to GitHub pages<br />
-h show help instructions

## Deploy to GitHub pages

* Copy the app and add as a repo under to your user repos in GitHub
* Configure app in GitHub to point pages to `/docs`
  * Settings -> Options -> GitHub Pages -> Source -> Branch: `main` and Folder: `/docs`
* Edit the area and regions in `/config/initializers/covid_regions.rb`
* run script:  `bin/update_site -s -p -g`
  * Generates files under `/docs`
  * Push results to GitHub
  * Run daily (manually or by cron job) and push results to GitHub

The app will be accessible at http://_Your_GitHub_Username_.github.io/covid_tracker/

## Acknowlegements

Data from: 
[COVID-19 Data Repository by the Center for Systems Science and Engineering (CSSE) at Johns Hopkins University](https://github.com/CSSEGISandData/COVID-19) 
(Terms of Use - scroll to bottom)

The API to access the data is 
[COVID API](https://documenter.getpostman.com/view/10724784/SzYXWz3x?version=latest#8b133941-d8b3-4055-8047-46171581cac4)

The mechanism used in the app to access the API is a custom module written to work with the
[Questioning Authority](https://github.com/samvera/questioning_authority) from the [Samvera Community](https://samvera.org). 

Graphs are generated using [Gruff Graph library](https://github.com/topfunky/gruff)

The GitHub Pages site uses [Documentation Theme for Jekyll](https://github.com/tomjohnson1492/documentation-theme-jekyll) 
