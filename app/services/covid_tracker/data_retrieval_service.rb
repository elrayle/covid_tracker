# frozen_string_literal: true

require 'covid_tracker/keys'

# This class creates fetches the data from the cache if available, otherwise from through the API
module CovidTracker
  class DataRetrievalService
    class_attribute :registry_class, :authority_class, :time_period_service
    self.registry_class = CovidTracker::RegionRegistry
    self.authority_class = CovidTracker::CovidApi
    self.time_period_service = CovidTracker::TimePeriodService

    DEFAULT_DAYS_TO_TRACK = 2

    class << self
      # TODO: Perhaps this should return an Array instead of a Hash
      # @param days [Integer] number of days of data to fetch
      # @param last_day [String] most recent day for which to collect data (e.g. "2020-09-22"); defaults to default_last_day (typically yesterday)
      # @return [Hash<String, CovidTracker::RegionResults] results for all registered regions across a range of dates
      def all_regions_data(days: DEFAULT_DAYS_TO_TRACK, last_day: default_last_day)
        all_results = {}
        registered_regions = registry_class.registry
        registered_regions.each do |region_registration|
          region_results = region_results(region_registration: region_registration, days: days, last_day: last_day)
          region_code = region_results.region_code
          all_results[region_code] = region_results
        end
        all_results
      end

      # def all_regions_data_in_range(date:)
      #   all_results = {}
      #   registered_regions = registry_class.registry
      #   registered_regions.each do |region_registration|
      #     region_results = region_results(region_registration: region_registration, days: 1, last_day: date)
      #     region_code = region_registration.id
      #     all_results[region_code] = region_results
      #   end
      #   all_results
      # end

      # @param region_registration [Hash] info identifying the region (e.g. { country_iso: 'USA', province_state: 'New York', admin2_county: 'Broome' })
      # @param days [Integer] number of days of data to fetch
      # @param last_day [String] most recent day that will be the last day of data gathered (e.g. "2020-05-31")
      # @return [CovidTracker::RegionResults] results for a region across a range of dates
      def region_results(region_registration:, days: DEFAULT_DAYS_TO_TRACK, last_day: default_last_day)
        region_data = []
        (days - 1).downto(0) do |day_idx|
          region_datum = fetch_for_date(last_day, day_idx, region_registration)
          region_datum.error? && can_shift?(day_idx, last_day) ? shift(region_data, last_day, days, region_registration) : region_data << region_datum
        end
        CovidTracker::RegionResults.new(region_registration: region_registration, region_data: region_data)
      end

      # Only shift an error if the error happens on the most recent day AND the most recent day (last_day) is the latest possible day
      def can_shift?(day_idx, last_day)
        day_idx.zero? && last_day == default_last_day
      end

      # This need to shift happens when the latest days data is not yet available.
      def shift(region_data, last_day, days, region_registration)
        # latest day's data not available yet, so need to get another day farther back
        region_datum = fetch_for_date(last_day, days, region_registration)
        region_data.unshift(region_datum) # get one more day back and insert it at the beginning
        # reset default last day to avoid having to make this fix for every region
        default_one_day_earlier
      end

      def region_data(region_results:)
        region_results.region_data
      end

      # @param region_results [CovidTracker::RegionResults] full set of data for a single region across a range of dates
      # @returns [String] label for the region (e.g. "Knox, Maine, USA")
      def region_label(region_results:)
        region_results.region_label
      end

      # @param region_results [CovidTracker::RegionResults] full set of data for a single region across a range of dates
      # @returns [String] code for the region (e.g. "usa_maine_knox")
      def region_code(region_results:)
        region_results.region_code
      end

      # TODO: Add configurations and set preferred timezone and data timezone there
      def data_time_zone
        authority_class::DATA_TIME_ZONE
      end

    private

      def fetch_for_date(last_day, day_idx, region_registration)
        date_str = time_period_service.str_date_from_idx(last_day, day_idx)
        datum = fetch_from_cache(region_registration: region_registration, date: date_str)
        return datum unless datum.blank?
        raw_datum = authority_class.new.find_for(region_registration: region_registration, date: date_str)
        CovidTracker::RegionDatum.for(raw_datum)
      end

      def fetch_from_cache(region_registration:, date:)
        count_data = CovidTracker::RegionCount.find_by(region_code: region_registration.code, date: date)
        return if count_data.empty?
        CovidTracker::RegionDatum.parse_datum(region_registration: region_registration, count_data: count_data)
      end

      def region_data_from_region_results(region_results)
        region_results.region_data
      end

      def default_last_day
        @default_last_day ||= authority_class.most_recent_day_with_data
      end

      def default_one_day_earlier
        # don't want to continue adjusting if there are errors for other reasons
        return false unless default_last_day == authority_class.most_recent_day_with_data
        @default_last_day = time_period_service.date_to_str(time_period_service.str_to_date(default_last_day) - 1.day)
      end
    end
  end
end
