# frozen_string_literal: true

require 'covid_tracker/keys'

module CovidTracker
  module CovidApiFormatter
  private

    def format_response(request:, result:)
      {
        CovidTracker::RequestKeys::REQUEST_SECTION => request,
        CovidTracker::ResultKeys::RESULT_SECTION => result
      }
    end

    def format_result(confirmed:, delta_confirmed:, deaths:, delta_deaths:)
      {
        CovidTracker::ResultKeys::RESULT_CODE => result_code, # e.g. '2020-04-04_usa-alabama-butler'
        CovidTracker::ResultKeys::RESULT_LABEL => result_label, # e.g. 'Butler, Alabama, USA (2020-04-04)'
        CovidTracker::ResultKeys::REGION_CODE => region_code, # e.g. 'usa-alabama-butler'
        CovidTracker::ResultKeys::REGION_LABEL => region_label, # e.g. 'Butler, Alabama, USA'
        CovidTracker::ResultKeys::DATE => date, # 'e.g. '2020-04-04'
        CovidTracker::ResultKeys::CUMULATIVE_CONFIRMED => confirmed,
        CovidTracker::ResultKeys::DELTA_CONFIRMED => delta_confirmed,
        CovidTracker::ResultKeys::CUMULATIVE_DEATHS => deaths,
        CovidTracker::ResultKeys::DELTA_DEATHS => delta_deaths
      }
    end

    def format_request(date, country_iso, province_state, admin2_county)
      request = { CovidTracker::RequestKeys::DATE => date }
      request[CovidTracker::RequestKeys::COUNTRY_ISO] = country_iso if country_iso # e.g. 'USA'
      request[CovidTracker::RequestKeys::PROVINCE_STATE] = province_state if province_state # e.g. 'Alabama'
      request[CovidTracker::RequestKeys::ADMIN2_COUNTY] = admin2_county if admin2_county # e.g. 'Butler'
      request
    end
  end
end
