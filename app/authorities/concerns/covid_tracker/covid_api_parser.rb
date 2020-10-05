# frozen_string_literal: true

require 'covid_tracker/keys'

module CovidTracker
  module CovidApiParser
  private

    # Data is returned differently depending on the region levels requested.  Parses data based on region parameters.
    def parse_authority_response
      formatted_request = format_request(date, country_iso, province_state, admin2_county)
      return format_response(request: formatted_request, result: { CovidTracker::ResultKeys::ERROR => error_msg }) if error?
      formatted_result = if admin2_county
                           parse_admin2_county
                         elsif province_state
                           parse_province_state
                         else
                           parse_country
                         end
      format_response(request: formatted_request, result: formatted_result)
    end

    def parse_admin2_county
      format_result(confirmed: admin2_county_data['confirmed'],
                    delta_confirmed: admin2_county_data['confirmed_diff'],
                    deaths: admin2_county_data['deaths'],
                    delta_deaths: admin2_county_data['deaths_diff'])
    end

    def admin2_county_data
      province_state_data['region']['cities'].first
    end

    def parse_province_state
      format_result(confirmed: province_state_data['confirmed'],
                    delta_confirmed: province_state_data['confirmed_diff'],
                    deaths: province_state_data['deaths'],
                    delta_deaths: province_state_data['deaths_diff'])
    end

    def province_state_data
      raw_response['data'].first
    end

    def parse_country
      cumulative_confirmed = 0
      delta_confirmed = 0
      cumulative_deaths = 0
      delta_deaths = 0
      raw_response['data'].each do |datum|
        cumulative_confirmed += datum["confirmed"]
        delta_confirmed += datum["confirmed_diff"]
        cumulative_deaths += datum["deaths"]
        delta_deaths += datum["deaths_diff"]
      end
      format_result(confirmed: cumulative_confirmed,
                    delta_confirmed: delta_confirmed,
                    deaths: cumulative_deaths,
                    delta_deaths: delta_deaths)
    end
  end
end
