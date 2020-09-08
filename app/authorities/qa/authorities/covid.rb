# frozen_string_literal: true

require 'covid_tracker/keys'

module Qa::Authorities
  # A wrapper around the Covid api for use with questioning_authority
  # API documentation: https://documenter.getpostman.com/view/10724784/SzYXWz3x?version=latest
  # QA URL: _YOUR_HOST_/api/search?date=2020-05-31&country_iso=USA&province_state=New York&county=Broome
  #
  # List of country ISO codes: https://covid-api.com/api/regions
  # List of US state names:    https://covid-api.com/api/provinces/usa
  # List of country province names (substitute country's ISO code for `:iso`):
  #                            https://covid-api.com/api/provinces/:iso
  #
  class Covid < Qa::Authorities::Base
    include WebServiceBase

    attr_reader :region_registration, :date, :error_msg, :raw_response

    DATA_TIME_ZONE = 'Eastern Time (US & Canada)'

    def self.most_recent_day_with_data
      (DateTime.now.in_time_zone(DATA_TIME_ZONE) - 1.day).strftime("%F")
    end

    delegate :most_recent_day_with_data, to: Qa::Authorities::Covid

    # used to test build_url
    # @param region_registration [CovidTracker::RegionRegistration] identifies country_iso, province_state, and admin2_county
    # @param date [String] date string in the format %F (e.g. "2020-05-31")
    def initialize(region_registration: nil, date: nil)
      unpack_registration(region_registration, date) if region_registration && date
    end

    # Covid returns json
    def response(url)
      Faraday.get(url) do |req|
        req.headers['Accept'] = 'application/json'
      end
    end

    # Find data for a specific region using the covid-api
    # @param region_registration [CovidTracker::RegionRegistration] identifies country_iso, province_state, and admin2_county
    # @param date [String] date string in the format %F (e.g. "2020-05-31")
    # @return json results with response_header and results
    def find_for(region_registration:, date:)
      unpack_registration(region_registration, date)
      query_api
    end

    # Find data for a specific region using the covid-api
    # @param region [Hash|ActiveRecord::Params] params from controller or passed in hash
    # @option region [String] :country_iso ISO code for country (e.g. "USA") (optional default="USA")
    # @option region [String] :province_state province or state name (e.g. "Georgia") (optional)
    # @option region [String] :admin2_county admin2 or county name (e.g. "Richmond") (optional)
    # @option region [String] :date date string in the format %F (e.g. "2020-05-31") (optional default=latest date with data)
    # @return json results with response_header and results
    def find(region)
      unpack_params(region)
      query_api
    end

    # Search the covid-api based on params from terms_controller
    # @param _query [String] the query
    # @param terms_controller [QA::TermsController] controller with params
    # @return json results with response_header and results
    def search(_query, terms_controller)
      find(terms_controller.params)
    end

    # Build a Covid-API url
    # @return [String] the url
    def build_query_url
      base_url = "https://covid-api.com/api/reports?"
      base_url = append_param(base_url, 'date', date)
      base_url = append_param(base_url, 'iso', country_iso)
      base_url = append_param(base_url, 'region_province', province_state)
      append_param(base_url, 'city_name', admin2_county)
    end

    private

      def query_api
        url = build_query_url
        begin
          @raw_response = json(url)
        rescue JSON::ParserError
          Rails.logger.info "Could not parse response as JSON. Request url: #{url}"
          return []
        end
        parse_authority_response
      end

      def append_param(base_url, name, value)
        return base_url unless value
        connector = base_url.end_with?('?') ? '' : '&'
        base_url + "#{connector}#{name}=#{value}"
      end

      # @param region_registration [CovidTracker::RegionRegistration] controller with params
      def unpack_registration(region_registration, date)
        @error_msg = ""
        @date = date
        @region_registration = region_registration
      end

      # @param params [Hash|ActiveRecord::Params] params from controller or passed in hash
      def unpack_params(params)
        @error_msg = ""
        @date = params.fetch('date', most_recent_day_with_data)
        @region_registration = CovidTracker::RegionRegistration.new(country_iso: params.fetch('country_iso', "USA"),
                                                                    province_state: params.fetch('province_state', nil),
                                                                    admin2_county: params.fetch('admin2_county', nil))
      end

      def format_request
        request = { CovidTracker::RequestKeys::DATE => date }
        request[CovidTracker::RequestKeys::COUNTRY_ISO] = country_iso if country_iso
        request[CovidTracker::RequestKeys::PROVINCE_STATE] = province_state if province_state
        request[CovidTracker::RequestKeys::ADMIN2_COUNTY] = admin2_county if admin2_county
        request
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

      # Data is returned differently depending on the region levels requested.  Parses data based on region parameters.
      def parse_authority_response
        return { error: error_msg } if error?
        formatted_results = if admin2_county
                              parse_admin2_county
                            elsif province_state
                              parse_province_state
                            else
                              parse_country
                            end
        {
          CovidTracker::RequestKeys::REQUEST_SECTION => format_request,
          CovidTracker::ResultKeys::RESULT_SECTION => formatted_results
        }
      end

      def parse_admin2_county
        cumulative_confirmed = raw_response['data'].first['region']['cities'].first['confirmed']
        delta_confirmed = raw_response['data'].first['region']['cities'].first['confirmed_diff']
        cumulative_death = raw_response['data'].first['region']['cities'].first['deaths']
        delta_deaths = raw_response['data'].first['region']['cities'].first['deaths_diff']
        format_results(confirmed: cumulative_confirmed,
                       delta_confirmed: delta_confirmed,
                       deaths: cumulative_death,
                       delta_deaths: delta_deaths)
      end

      def parse_province_state
        cumulative_confirmed = raw_response['data'].first['confirmed']
        delta_confirmed = raw_response['data'].first['confirmed_diff']
        cumulative_death = raw_response['data'].first['deaths']
        delta_deaths = raw_response['data'].first['deaths_diff']
        format_results(confirmed: cumulative_confirmed,
                       delta_confirmed: delta_confirmed,
                       deaths: cumulative_death,
                       delta_deaths: delta_deaths)
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
        format_results(confirmed: cumulative_confirmed,
                       delta_confirmed: delta_confirmed,
                       deaths: cumulative_deaths,
                       delta_deaths: delta_deaths)
      end

      def id
        date + region_id
      end

      def region_id
        region_registration.id
      end

      def label
        label = region_label + "(#{date})"
      end

      def region_label
        region_registration.label
      end

      def country_iso
        region_registration.country_iso
      end

      def province_state
        region_registration.province_state
      end

      def admin2_county
        region_registration.admin2_county
      end

      def error_check
        return unless raw_response['data'].empty?
        @error_msg = "No data on #{date}"
        @error_msg += " for country_iso: #{country_iso}" if country_iso
        @error_msg += ", province_state: #{province_state}" if province_state
        @error_msg += ", admin2_county: #{admin2_county}" if admin2_county
      end

      def error?
        error_check
        !error_msg.blank?
      end
  end
end
