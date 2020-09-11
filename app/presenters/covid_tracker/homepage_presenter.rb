# frozen_string_literal: true

require 'covid_tracker/keys'

# This presenter class provides all data needed by the view that monitors status of authorities.
module CovidTracker
  class HomepagePresenter
    class_attribute :data_service_class
    self.data_service_class = CovidTracker::DataService

    attr_reader :all_regions_data

    delegate :region_label, :region_data, to: data_service_class

    # @param all_results [Hash] results for all registered regions
    def initialize(all_regions_data:)
      @all_regions_data = all_regions_data
    end

    def result(datum)
      datum[CovidTracker::ResultKeys::RESULT_SECTION]
    end

    def row_class(idx)
      idx.odd? ? "pure-table-even" : "pure-table-odd"
    end

    def date(datum)
      result(datum)[CovidTracker::ResultKeys::DATE]
    end

    def date_class(datum)
      "neutral"
    end

    def cumulative_confirmed(datum)
      result(datum)[CovidTracker::ResultKeys::CUMULATIVE_CONFIRMED]
    end

    def cumulative_confirmed_class(datum)
      "neutral"
    end

    def delta_confirmed(datum)
      delta_confirmed_count = result(datum)[CovidTracker::ResultKeys::DELTA_CONFIRMED]
      delta_confirmed_count.zero? ? "-" : delta_confirmed_count
    end

    def delta_confirmed_class(datum)
      datum_class(value: delta_confirmed(datum), low_threshold: 0, moderate_threshold: 5, critical_threshold: 10)
    end

    def cumulative_deaths(datum)
      result(datum)[CovidTracker::ResultKeys::CUMULATIVE_DEATHS]
    end

    def cumulative_deaths_class(datum)
      "neutral"
    end

    def delta_deaths(datum)
      delta_deaths_count = result(datum)[CovidTracker::ResultKeys::DELTA_DEATHS]
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
