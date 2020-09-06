# elrayle.github.io/covid_tracker

## How Does This Work?

This a GitHub Pages site using Jekyll-based custom theme for markup and display.  This site is published http://elrayle.github.io/covid_tracker.

### Accompanying Rails App

Covid Tracker is a configurable 

## Adapting for your customizations

* edit /config/initializers/covid_regions.rb and register the regions in which you are interested
* generate the graphs - TODO: provide details

### Setting up the site for your regions

TODO: put rails app instructions in rails app README and Jekyll site instructions in this README

1) fork this project in GitHub
2) clone your fork 
```
git clone git@github.com:your_organization/covid_tracker.git
cd covid_tracker
```
3) get dependencies
```
cd docs
bundle install --path=vendor/bundle
```

#### To Test on your local machine:

From `covid_tracker/docs` directory
```
rm -R -f _site
SAVE_GENERATED_FILES=1 bundle exec jekyll build
bundle exec jekyll serve
```

View the site in a browser at http://localhost:4000

### Browse pages

This site includes a generated browse page. Each page's frontmatter `keywords` values are used to populate the browse by keyword page. The keywords should be written as titles, in upper and lower case, as they will be directly used as text on the page.

When changes are committed, the page needs to be regenerated and included with the committed changes. To build and save the revised `browse_pages.html` file:
  * Run command `SAVE_GENERATED_FILES=1 bundle exec jekyll build`

Be sure to include the generated file in your pull request.

## Acknowlegements

Data from: 
[COVID-19 Data Repository by the Center for Systems Science and Engineering (CSSE) at Johns Hopkins University](https://github.com/CSSEGISandData/COVID-19) 
(Terms of Use - scroll to bottom)

The API to access the COVID-19 data is 
[COVID API](https://documenter.getpostman.com/view/10724784/SzYXWz3x?version=latest#8b133941-d8b3-4055-8047-46171581cac4)

The mechanism used in the app to access the API is a custom module written to work with the
[Questioning Authority](https://github.com/samvera/questioning_authority) from the [Samvera Community](https://samvera.org). 

The GitHub Pages site uses [Documentation Theme for Jekyll](https://github.com/tomjohnson1492/documentation-theme-jekyll) developed by [Tom Johnson](https://github.com/tomjohnson1492).
