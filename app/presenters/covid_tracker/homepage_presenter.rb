# frozen_string_literal: true

require 'covid_tracker/keys'

# This presenter class provides all data needed by the view that monitors status of authorities.
module CovidTracker
  class HomepagePresenter
    class_attribute :data_service
    self.data_service = CovidTracker::DataService

    attr_reader :all_regions_data

    # TODO: datum is not an instance of CovidTracker::RegionDatum
    delegate :result, :date, :cumulative_confirmed, :cumulative_deaths, :region_label, :region_code, :region_data, to: data_service

    # @param all_results [Hash] results for all registered regions
    def initialize(all_regions_data:)
      @all_regions_data = all_regions_data
    end

    def row_class(idx)
      idx.odd? ? "pure-table-even" : "pure-table-odd"
    end

    def date_class(_datum)
      "neutral"
    end

    def cumulative_confirmed_class(_datum)
      "neutral"
    end

    def delta_confirmed(datum)
      delta_confirmed_count = data_service.delta_confirmed(datum)
      delta_confirmed_count.zero? ? "-" : delta_confirmed_count
    end

    def delta_confirmed_class(datum)
      datum_class(value: delta_confirmed(datum), low_threshold: 0, moderate_threshold: 5, critical_threshold: 10)
    end

    def cumulative_deaths_class(_datum)
      "neutral"
    end

    def delta_deaths(datum)
      delta_deaths_count = data_service.delta_deaths(datum)
      delta_deaths_count.zero? ? "-" : delta_deaths_count
    end

    def delta_deaths_class(datum)
      datum_class(value: delta_deaths(datum), low_threshold: 0, moderate_threshold: 5, critical_threshold: 10)
    end

    def datum_class(value:, low_threshold: 0, moderate_threshold: 5, critical_threshold: 10)
      return "neutral" unless value.is_a? Integer
      return "critical" if value > critical_threshold
      return "moderate" if value > moderate_threshold
      return "low" if value > low_threshold
      "neutral"
    end
  end
end
