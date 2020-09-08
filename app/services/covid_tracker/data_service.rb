# frozen_string_literal: true

require 'covid_tracker/keys'

# This class creates the data structure holding the requested results for each stat tracked.
#
# Expected structure of data returned by homepage_controller.rb
# {
#   ":USA:New_York:Cortland" => {
#     region_label: "Cortland, New York, USA",
#     region_data: [
#       {
#         result: {
#           id: "2020-05-31:USA:New_York:Cortland",
#           label: "Cortland, New York, USA (2020-05-31)",
#           region_id: ":USA:New_York:Cortland",
#           region_label: "Cortland, New York, USA",
#           date: "2020-05-31",
#           cumulative_confirmed: 203,
#           delta_confirmed: 3,
#           cumulative_deaths: 5,
#           delta_deaths: 0
#         }
#         request: {
#           date: "2020-05-31",
#           country_iso: "USA",
#           province_state: "New York",
#           admin2_county: "Cortland"
#         }
#       },
#       ...     # more data for same region
#     ]
#   },
#   ...    # next region
# }
#
# Interpret this as...
# all_regions_data = { region_id => region_results, ... }
# region_results = { region_label, region_data }
# region_data = [ { result_for_day, request_with_date }, ... ] # sorted oldest to newest
#
module CovidTracker
  class DataService

    DEFAULT_DAYS_TO_TRACK = 2

    class_attribute :registry_class
    self.registry_class = CovidTracker::RegionRegistry

    # @param days [Integer] number of days of data to fetch
    # @return [Hash] full set of data for all configured regions - see example in class documentation
    class << self
      def all_regions_data(days: DEFAULT_DAYS_TO_TRACK)
        all_results = {}
        registered_regions = registry_class.registry
        registered_regions.each do |region_registration|
          region_results = region_results(region_registration: region_registration, days: days, last_day: default_last_day)
          region_id = region_registration.id
          all_results[region_id] = region_results
        end
        all_results
      end

      # @param region_registration [Hash] info identifying the region (e.g. { country_iso: 'USA', province_state: 'New York', admin2_county: 'Broome' })
      # @param days [Integer] number of days of data to fetch
      # @param last_day [String] most recent day that will be the last day of data gathered (e.g. "2020-05-31")
      # @return [Hash] full set of data for a single region - see example in class documentation
      def region_results(region_registration:, days: DEFAULT_DAYS_TO_TRACK, last_day: default_last_day)
        region_data = []
        (days - 1).downto(0) do |day_idx|
          result = fetch_for_date(last_day, day_idx, region_registration)
          if result.key?(:error) && day_idx.zero? && last_day == default_last_day
            # latest day's data not available yet, so need to get another day farther back
            result = fetch_for_date(last_day, days, region_registration)
            region_data.unshift(result) # get one more day back and insert it at the beginning
            # reset default last day to avoid having to make this fix for every region
            default_one_day_earlier
          else
            region_data << result
          end
        end
        { CovidTracker::RegionKeys::REGION_LABEL => region_registration.label,
          CovidTracker::RegionKeys::REGION_DATA => region_data }
      end

      # def region_results(all_results, region_id)
      #   all_results[region_id]
      # end

      # TODO: Potential refactor in callers to use registration instead of results
      def region_label(region_results:)
        region_results[CovidTracker::RegionKeys::REGION_LABEL]
      end

      def region_data(region_results:)
        region_results[CovidTracker::RegionKeys::REGION_DATA]
      end

      # TODO: Potential refactor in callers to use registration instead of results
      def region_id_from_region_data(region_data:)
        region_data.first[CovidTracker::ResultKeys::RESULT_SECTION][CovidTracker::ResultKeys::REGION_ID]
      end

      private

        def fetch_for_date(last_day, day_idx, region_registration)
          date_str = str_date_from_idx(last_day, day_idx)
          Qa::Authorities::Covid.new.find_for(region_registration: region_registration, date: date_str)
        end

        def region_data_from_region_results(region_results)
          region_results[CovidTracker::RegionKeys::REGION_DATA]
        end

        def default_last_day
          @default_last_day ||= Qa::Authorities::Covid.most_recent_day_with_data
        end

        def default_one_day_earlier
          # don't want to continue adjusting if there are errors for other reasons
          return false unless default_last_day == Qa::Authorities::Covid.most_recent_day_with_data
          @default_last_day = date_to_str(str_to_date(default_last_day) - 1.day)
        end

        def str_date_from_idx(date_str, idx)
          date_to_str(str_to_date(date_str) - idx.days)
        end

        def str_to_date(date_str)
          Date.strptime(date_str, "%F")
        end

        def date_to_str(date)
          date.strftime("%F")
        end
    end
  end
end
