# frozen_string_literal: true

# This presenter class provides all data needed by the view that monitors status of authorities.
module CovidTracker
  class DataService
    class << self
      # @param region_results [CovidTracker::RegionResults] results for a region
      # @returns [String] label for the region (e.g. "Butler, Alabama, USA")
      def region_label(region_results:)
        region_results.region_label
      end

      # @param region_results [CovidTracker::RegionResults] results for a region
      # @returns [String] code for the region (e.g. "usa-alabama-butler")
      def region_code(region_results:)
        region_results.region_code
      end

      # @param region_results [CovidTracker::RegionResults] results for a region
      # @returns [Array<CovidTracker::RegionDatum>] data for the region for a range of dates
      def region_data(region_results:)
        region_results.region_data
      end

      # @param region_datum [CovidTracker::RegionDatum] result and request info for a region on a date
      # @returns [CovidTracker::Result] the result section within region_datum
      def result(region_datum)
        region_datum.result
      end

      # @param region_datum [CovidTracker::RegionDatum] result and request info for a region on a date
      # @returns [String] the result code (e.g. "2020-04-04_usa-alabama-butler")
      def result_code(region_datum)
        result(region_datum).result_code
      end

      # @param region_datum [CovidTracker::RegionDatum] result and request info for a region on a date
      # @returns [String] the result label (e.g. "Butler, Alabama, USA (2020-04-04)")
      def result_label(region_datum)
        result(region_datum).result_label
      end

      # @param region_datum [CovidTracker::RegionDatum] result and request info for a region on a date
      # @returns [String] the date of the result (e.g. "2020-04-04")
      def date(region_datum)
        result(region_datum).date
      end

      # @param region_datum [CovidTracker::RegionDatum] result and request info for a region on a date
      # @returns [Integer] the cumulative count of confirmed cases
      def cumulative_confirmed(region_datum)
        result(region_datum).cumulative_confirmed
      end

      # @param region_datum [CovidTracker::RegionDatum] result and request info for a region on a date
      # @returns [Integer] the change in the count of confirmed cases
      def delta_confirmed(region_datum)
        result(region_datum).delta_confirmed
      end

      # @param region_datum [CovidTracker::RegionDatum] result and request info for a region on a date
      # @returns [Integer] the cumulative count of confirmed deaths
      def cumulative_deaths(region_datum)
        result(region_datum).cumulative_deaths
      end

      # @param region_datum [CovidTracker::RegionDatum] result and request info for a region on a date
      # @returns [Integer] the change in the count of confirmed deaths
      def delta_deaths(region_datum)
        result(region_datum).delta_deaths
      end

      # @param region_datum [CovidTracker::RegionDatum] result and request info for a region on a date
      # @returns [Integer] the cumulative count of confirmed cases for the last 7 days
      def cumulative_7_days_confirmed(region_datum)
        result(region_datum).cumulative_7_days_confirmed
      end

      # @param region_datum [CovidTracker::RegionDatum] result and request info for a region on a date
      # @returns [CovidTracker::Request] the request section within region_datum
      def request(region_datum)
        region_datum.request
      end

      # @param region_datum [CovidTracker::RegionDatum] result and request info for a region on a date
      # @returns [String] the country_iso from the request
      def country_iso(region_datum)
        request(region_datum).country_iso
      end

      # @param region_datum [CovidTracker::RegionDatum] result and request info for a region on a date
      # @returns [String] the province_state from the request
      def province_state(region_datum)
        request(region_datum).province_state
      end

      # @param region_datum [CovidTracker::RegionDatum] result and request info for a region on a date
      # @returns [String] the admin2_county from the request
      def admin2_county(region_datum)
        request(region_datum).admin2_county
      end
    end
  end
end
