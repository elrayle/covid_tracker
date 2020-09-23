# frozen_string_literal: true

require 'covid_tracker/keys'

# This presenter class provides all data needed by the view that monitors status of authorities.
module CovidTracker
  class DataService
    class << self
      def result(datum)
        datum[CovidTracker::ResultKeys::RESULT_SECTION]
      end

      def result_id(datum)
        result(datum)[CovidTracker::ResultKeys::ID]
      end

      def result_label(datum)
        result(datum)[CovidTracker::ResultKeys::LABEL]
      end

      def region_id(datum)
        result(datum)[CovidTracker::ResultKeys::REGION_ID]
      end

      def region_label(datum)
        result(datum)[CovidTracker::ResultKeys::REGION_LABEL]
      end

      def date(datum)
        result(datum)[CovidTracker::ResultKeys::DATE]
      end

      def cumulative_confirmed(datum)
        result(datum)[CovidTracker::ResultKeys::CUMULATIVE_CONFIRMED]
      end

      def delta_confirmed(datum)
        delta_confirmed_count = result(datum)[CovidTracker::ResultKeys::DELTA_CONFIRMED]
      end

      def cumulative_deaths(datum)
        result(datum)[CovidTracker::ResultKeys::CUMULATIVE_DEATHS]
      end

      def delta_deaths(datum)
        delta_deaths_count = result(datum)[CovidTracker::ResultKeys::DELTA_DEATHS]
      end

      def request(datum)
        datum[CovidTracker::RequestKeys::REQUEST_SECTION]
      end

      def country_iso(datum)
        request(datum)[CovidTracker::RequestKeys::COUNTRY_ISO]
      end

      def province_state(datum)
        request(datum)[CovidTracker::RequestKeys::PROVINCE_STATE]
      end

      def admin2_county(datum)
        request(datum)[CovidTracker::RequestKeys::ADMIN2_COUNTY]
      end
    end
  end
end
