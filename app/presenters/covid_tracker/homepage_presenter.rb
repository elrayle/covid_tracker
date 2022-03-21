# frozen_string_literal: true

require 'covid_tracker/keys'

# This presenter class provides all data needed by the view that monitors status of authorities.
module CovidTracker
  class HomepagePresenter
    class_attribute :data_service
    self.data_service = CovidTracker::DataService

    attr_reader :region_results

    delegate :result, :date, :cumulative_confirmed, :rolling_7_days_confirmed, :rolling_7_days_deaths,
             :cumulative_deaths, :region_label, :region_code, :region_data, to: data_service

    # @param region_results [Hash<String, CovidTracker::RegionResults] results for all registered regions across a range of dates
    def initialize(region_results:)
      @region_results = region_results
    end

    # @param idx [Integer] row number
    # @returns [String] css for table row
    def row_class(idx)
      idx.odd? ? "pure-table-odd" : "pure-table-even"
    end

    # @param _datum [CovidTracker::RegionDatum] result and request info for a region on a date
    # @returns [String] css for table cell
    def date_class(_datum)
      "neutral"
    end

    # @param _datum [CovidTracker::RegionDatum] result and request info for a region on a date
    # @returns [String] css for table cell
    def cumulative_confirmed_class(_datum)
      "neutral"
    end

    # @param _datum [CovidTracker::RegionDatum] result and request info for a region on a date
    # @returns [String] css for table cell
    def rolling_7_days_confirmed_class(_datum)
      "neutral"
    end

    # @param datum [CovidTracker::RegionDatum] result and request info for a region on a date
    # @returns [Integer] the change in the count of confirmed cases or a dash if change is 0
    def delta_confirmed(datum)
      delta_confirmed_count = data_service.delta_confirmed(datum)
      delta_confirmed_count.zero? ? "-" : delta_confirmed_count
    end

    # @param datum [CovidTracker::RegionDatum] result and request info for a region on a date
    # @returns [String] css for table cell
    def delta_confirmed_class(datum)
      datum_class(value: delta_confirmed(datum), low_threshold: 0, moderate_threshold: 5, critical_threshold: 10)
    end

    # @param _datum [CovidTracker::RegionDatum] result and request info for a region on a date
    # @returns [String] css for table cell
    def cumulative_deaths_class(_datum)
      "neutral"
    end

    # @param _datum [CovidTracker::RegionDatum] result and request info for a region on a date
    # @returns [String] css for table cell
    def rolling_7_days_deaths_class(_datum)
      "neutral"
    end

    # @param datum [CovidTracker::RegionDatum] result and request info for a region on a date
    # @returns [Integer] the change in the count of confirmed deaths or a dash if change is 0
    def delta_deaths(datum)
      delta_deaths_count = data_service.delta_deaths(datum)
      delta_deaths_count.zero? ? "-" : delta_deaths_count
    end

    # @param datum [CovidTracker::RegionDatum] result and request info for a region on a date
    # @returns [String] css for table cell
    def delta_deaths_class(datum)
      datum_class(value: delta_deaths(datum), low_threshold: 0, moderate_threshold: 5, critical_threshold: 10)
    end

  private

    def datum_class(value:, low_threshold: 0, moderate_threshold: 5, critical_threshold: 10)
      return "neutral" unless value.is_a? Integer
      return "critical" if value > critical_threshold
      return "moderate" if value > moderate_threshold
      return "low" if value > low_threshold
      "neutral"
    end
  end
end
