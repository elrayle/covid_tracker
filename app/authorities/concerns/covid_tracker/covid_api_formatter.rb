# frozen_string_literal: true

require 'covid_tracker/keys'

module CovidTracker
  module CovidApiFormatter
  private

    def format_response(request:, results:)
      {
        CovidTracker::RequestKeys::REQUEST_SECTION => request,
        CovidTracker::ResultKeys::RESULT_SECTION => results
      }
    end

    def format_results(confirmed:, delta_confirmed:, deaths:, delta_deaths:)
      {
        CovidTracker::ResultKeys::ID => id,
        CovidTracker::ResultKeys::LABEL => label,
        CovidTracker::ResultKeys::REGION_ID => region_id,
        CovidTracker::ResultKeys::REGION_LABEL => region_label,
        CovidTracker::ResultKeys::DATE => date,
        CovidTracker::ResultKeys::CUMULATIVE_CONFIRMED => confirmed,
        CovidTracker::ResultKeys::DELTA_CONFIRMED => delta_confirmed,
        CovidTracker::ResultKeys::CUMULATIVE_DEATHS => deaths,
        CovidTracker::ResultKeys::DELTA_DEATHS => delta_deaths
      }
    end

    def format_request(date, country_iso, province_state, admin2_county)
      request = { CovidTracker::RequestKeys::DATE => date }
      request[CovidTracker::RequestKeys::COUNTRY_ISO] = country_iso if country_iso
      request[CovidTracker::RequestKeys::PROVINCE_STATE] = province_state if province_state
      request[CovidTracker::RequestKeys::ADMIN2_COUNTY] = admin2_county if admin2_county
      request
    end
  end
end
