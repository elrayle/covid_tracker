module CovidTracker
  class CacheService
    include CovidTracker::CovidApiFormatter

    CUMULATIVE_CONFIRMED = CovidTracker::ResultKeys::CUMULATIVE_CONFIRMED
    DELTA_CONFIRMED = CovidTracker::ResultKeys::DELTA_CONFIRMED
    CUMULATIVE_DEATHS = CovidTracker::ResultKeys::CUMULATIVE_DEATHS
    DELTA_DEATHS = CovidTracker::ResultKeys::DELTA_DEATHS

    class << self
      # @param days [Integer] number of days of data to fetch
      # @param last_day [String] most recent day for which to collect data (e.g. "2020-09-22"); defaults to default_last_day (typically yesterday)
      # @returns [Hash] request and results
      def self.find_for(region_registration:, date:)
        region_counts = CovidTracker::RegionCount.find_by(region_code: region_registration.id, date: date_str)
        return request_thru_api(region_registration, date) if region_counts.blank?
        format(region_registration, date, region_counts)
      end

    private

      def format(region_registration, date, region_counts)
        formatted_results = format_results(confirmed: region_counts.confirmed_cases,
                                           delta_confirmed: region_counts.delta_cases,
                                           deaths: region_counts.confirmed_deaths,
                                           delta_deaths: region_counts.delta_deaths)
        formatted_request = format_request(date, 
                                           region_registration.country_iso, 
                                           region_registration.province_state, 
                                           region_registration.admin2_county)
        format_response(request: formatted_request, results: formatted_results)
      end

      def request_thru_api(region_registration, date)
        response = authority_class.new.find_for(region_registration: region_registration, date: date_str)
        CovidTracker::RegionCount.new(region_code: region_registration.id, date: date, data: )

  end
end
