# frozen_string_literal: true

module CovidTracker
  ##
  # This registry determines which locations will be processed by the CovidTracker.
  #
  # Region specifications vary from country to country.  The API has 3 levels of data referred to by...
  # * ISO - country code (see list at: https://covid-api.com/api/regions)
  # * province - For US, this is the state.  At this writing, for Germany, province is city.  And Finland does not track
  #     data on a scale smaller than country.  (see US list at: https://covid-api.com/api/provinces/usa; To see other countries,
  #     use the same URL substituting the country's ISO for usa.)
  # * city - For US, this is the county.  At this writing, it does not appear that other countries have this level.
  #
  # To help make the registry easier to understand, there are currently two registry methods.  Other country specific registry
  # methods could be added later.
  # * register_usa(state:, county:) # state and county are optional
  # * register(country_iso:, province:, city:) # province and city are optional
  #
  # The following example registry includes entries to find...
  # * specific counties in New York state in the US
  # * all counties in Georgia state in the US
  # * all entries for China
  #
  # To build a location registry, put register statements in /config/initializers/covid_locations.rb using...
  # ```
  #   CovidTracker::RegionRegistry.register_usa(state: 'New York', county: 'Cortland')
  #   CovidTracker::RegionRegistry.register_usa(state: 'New York', county: 'Tompkins')
  #   CovidTracker::RegionRegistry.register_usa(state: 'Georgia')
  #   CovidTracker::RegionRegistry.register(country_iso: 'DEU', province_state: 'Berlin')
  #   CovidTracker::RegionRegistry.register(country_iso: 'CHN')
  # ```
  #
  # This produces the following Registry...
  #   [ { country_iso: 'USA', province_state: 'New York', admin2_county: 'Cortland' },
  #     { country_iso: 'USA', province_state: 'New York', admin2_county: 'Tompkins' },
  #     { country_iso: 'USA', province_state: 'Georgia' },
  #     { country_iso: 'DEU', province_state: 'Berlin' },
  #     { country_iso: 'CHN' } ]
  #
  class RegionRegistry
    include Singleton

    def self.register_usa(*args)
      instance.register_usa(*args)
    end

    def self.register(*args)
      instance.register(*args)
    end

    def self.registry
      instance.registry
    end

    def self.clear_registry
      instance.clear_registry
    end

    def initialize
      @regions = []
    end

    def register_usa(state: nil, county: nil)
      register(country_iso: 'USA', province_state: state, admin2_county: county)
    end

    def register(country_iso:, province_state: nil, admin2_county: nil)
      region = {}.with_indifferent_access
      region[:country_iso] = country_iso
      region[:province_state] = province_state if province_state
      region[:admin2_county] = admin2_county if province_state && admin2_county # must specify province to use admin2; otherwise, ignored
      @regions << region
    end

    def registry
      @regions
    end

    def clear_registry
      @regions = []
    end
  end
end
