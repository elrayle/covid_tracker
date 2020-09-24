# frozen_string_literal: true

require 'covid_tracker/keys'

# This presenter class provides all data needed by the view that monitors status of authorities.
module CovidTracker
  class DataService
    class << self
      # @param region_data [Hash] structured data for a single date in a single region
      # @returns [Hash] the result section within region_data structure
      def result(region_data)
        region_data[CovidTracker::ResultKeys::RESULT_SECTION]
      end

      def result_id(region_data)
        result(region_data)[CovidTracker::ResultKeys::ID]
      end

      def result_label(region_data)
        result(region_data)[CovidTracker::ResultKeys::LABEL]
      end

      def region_id(region_data)
        result(region_data)[CovidTracker::ResultKeys::REGION_ID]
      end

      def region_label(region_data)
        result(region_data)[CovidTracker::ResultKeys::REGION_LABEL]
      end

      def date(region_data)
        result(region_data)[CovidTracker::ResultKeys::DATE]
      end

      def cumulative_confirmed(region_data)
        result(region_data)[CovidTracker::ResultKeys::CUMULATIVE_CONFIRMED]
      end

      def delta_confirmed(region_data)
        delta_confirmed_count = result(region_data)[CovidTracker::ResultKeys::DELTA_CONFIRMED]
      end

      def cumulative_deaths(region_data)
        result(region_data)[CovidTracker::ResultKeys::CUMULATIVE_DEATHS]
      end

      def delta_deaths(region_data)
        delta_deaths_count = result(region_data)[CovidTracker::ResultKeys::DELTA_DEATHS]
      end

      def request(region_data)
        region_data[CovidTracker::RequestKeys::REQUEST_SECTION]
      end

      def country_iso(region_data)
        request(region_data)[CovidTracker::RequestKeys::COUNTRY_ISO]
      end

      def province_state(region_data)
        request(region_data)[CovidTracker::RequestKeys::PROVINCE_STATE]
      end

      def admin2_county(region_data)
        request(region_data)[CovidTracker::RequestKeys::ADMIN2_COUNTY]
      end
    end
  end
end
