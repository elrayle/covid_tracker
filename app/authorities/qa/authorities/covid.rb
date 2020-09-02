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

    # Search the FAST api
    #
    # @param _query [String] the query
    # @param terms_controller [QA::TermsController] controller with params
    # @return json results with response_header and results
    def search(_query, terms_controller)
      unpack_params(terms_controller)
      url = build_query_url
      begin
        @raw_response = json(url)
      rescue JSON::ParserError
        Rails.logger.info "Could not parse response as JSON. Request url: #{url}"
        return []
      end
      parse_authority_response
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

      # @param terms_controller [QA::TermsController] controller with params
      def unpack_params(terms_controller)
        @error_msg = ""
        @date = terms_controller.params.fetch('date', (DateTime.now.in_time_zone(DATA_TIME_ZONE) - 1.day).strftime("%F"))
        @country_iso = terms_controller.params.fetch('country_iso', "USA")
        @province_state = terms_controller.params.fetch('province_state', nil)
        @admin2_county = terms_controller.params.fetch('admin2_county', nil)
      end

      def format_request
        request = { date: date }
        request[:country_iso] = country_iso if country_iso
        request[:province_state] = province_state if province_state
        request[:admin2_county] = admin2_county if admin2_county
        request
      end

      def format_results(id:, label:, confirmed:, deaths:)
        {
          id: id,
          label: label,
          date: date,
          cumulative_confirmed: confirmed,
          cumulative_death: deaths
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
        cumulative_death = raw_response['data'].first['region']['cities'].first['deaths']
        format_results(id: id,
                       label: label,
                       confirmed: cumulative_confirmed,
                       deaths: cumulative_death)
      end

      def parse_province_state
        cumulative_confirmed = raw_response['data'].first['confirmed']
        cumulative_death = raw_response['data'].first['deaths']
        format_results(id: id,
                       label: label,
                       confirmed: cumulative_confirmed,
                       deaths: cumulative_death)
      end

      def parse_country
        cumulative_confirmed = 0
        cumulative_death = 0
        raw_response['data'].each do |datum|
          cumulative_confirmed += datum["confirmed"]
          cumulative_death += datum["deaths"]
        end
        format_results(id: id,
                       label: label,
                       confirmed: cumulative_confirmed,
                       deaths: cumulative_death)
      end

      def id
        id = date
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
