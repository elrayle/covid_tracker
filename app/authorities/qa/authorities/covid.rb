# frozen_string_literal: true

module Qa::Authorities
  # A wrapper around the Covid api for use with questioning_authority
  # API documentation: https://documenter.getpostman.com/view/10724784/SzYXWz3x?version=latest
  # QA URL: _YOUR_HOST_/api/search?date=2020-05-31&country_iso=USA&province_state=New York&county=Broome
  #
  class Covid < Qa::Authorities::Base
    include WebServiceBase

    attr_reader :country_iso, :province_state, :admin2_county, :date, :error_msg, :raw_response

    DATA_TIME_ZONE = 'Eastern Time (US & Canada)'

    # Covid returns json
    def response(url)
      Faraday.get(url) do |req|
        req.headers['Accept'] = 'application/json'
      end
    end

    # Find data for a specific region using the covid-api
    def find(region)
      unpack_params(region)
      url = build_query_url
      begin
        @raw_response = json(url)
      rescue JSON::ParserError
        Rails.logger.info "Could not parse response as JSON. Request url: #{url}"
        return []
      end
      parse_authority_response
    end

    # Search the covid-api based on params from terms_controller
    #
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

      def append_param(base_url, name, value)
        return base_url unless value
        connector = base_url.end_with?('?') ? '' : '&'
        base_url + "#{connector}#{name}=#{value}"
      end

      # @param params [Hash|ActiveRecord::Params] controller with params
      def unpack_params(params)
        @error_msg = ""
        @date = params.fetch('date', (DateTime.now.in_time_zone(DATA_TIME_ZONE) - 1.day).strftime("%F"))
        @country_iso = params.fetch('country_iso', "USA")
        @province_state = params.fetch('province_state', nil)
        @admin2_county = params.fetch('admin2_county', nil)
      end

      def format_request
        request = { date: date }
        request[:country_iso] = country_iso if country_iso
        request[:province_state] = province_state if province_state
        request[:admin2_county] = admin2_county if admin2_county
        request
      end

      def format_results(confirmed:, delta_confirmed:, deaths:, delta_deaths:)
        {
          id: id,
          region_id: region_id,
          label: label,
          date: date,
          cumulative_confirmed: confirmed,
          delta_confirmed: delta_confirmed,
          cumulative_deaths: deaths,
          delta_deaths: delta_deaths
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
          request: format_request,
          results: formatted_results
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
        id = ""
        id += ":#{country_iso}" if country_iso
        id += ":#{province_state}" if province_state
        id += ":#{admin2_county}" if admin2_county
        id.gsub(' ', '_')
      end

      def label
        label = ""
        label += "#{raw_response['data'].first['region']['cities'].first['name']}, " if admin2_county
        label += "#{raw_response['data'].first['region']['province']}, " if province_state
        label += "#{raw_response['data'].first['region']['name']} " if country_iso
        label += "(#{date})"
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
