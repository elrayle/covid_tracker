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
# all_results = { region_id => region_results }
# region_results = { region_label, region_data }
# region_data = [ { result_for_day, request_with_date } ]
#
module CovidTracker
  class DataService

    DEFAULT_DAYS_TO_TRACK = 30

    class_attribute :registry_class
    self.registry_class = CovidTracker::RegionRegistry

    class << self
      def data_for_all_regions(days: DEFAULT_DAYS_TO_TRACK)
        all_results = {}
        registered_regions = registry_class.registry
        registered_regions.each do |region_registration|
          region_results = region_results(region_registration: region_registration, days: days, last_day: default_last_day)
          region_id = region_id_from_region_results(region_results)
          all_results[region_id] = region_results
        end
        all_results
      end

      # @param region [Hash] info identifying the region (e.g. { country_iso: 'USA', province_state: 'New York', admin2_county: 'Broome' })
      def region_results(region_registration:, days: DEFAULT_DAYS_TO_TRACK, last_day: default_last_day)
        region_registration_with_date = region_registration
        region_data = []
        1.upto(days) do |dti|
          date_str = (dt_last_day(last_day) - dti.days).strftime("%F")
          region_registration_with_date[:date] = date_str
          region_data << Qa::Authorities::Covid.new.find(region_registration_with_date)
        end
        { CovidTracker::RegionKeys::REGION_LABEL => region_label_from_region_data(region_data),
          CovidTracker::RegionKeys::REGION_DATA => region_data }
      end

      # def region_results(all_results, region_id)
      #   all_results[region_id]
      # end
      #
      # def region_label(all_results, region_id)
      #   region_results(all_results, region_id)[CovidTracker::RegionKeys::REGION_LABEL]
      # end
      #
      # def region_data(all_results, region_id)
      #   region_results(all_results, region_id)[CovidTracker::RegionKeys::REGION_DATA]
      # end

      private

        def region_data_from_region_results(region_results)
          region_results[CovidTracker::RegionKeys::REGION_DATA]
        end

        def region_id_from_region_results(region_results)
          region_data = region_data_from_region_results(region_results)
          region_data.first[CovidTracker::ResultKeys::RESULT_SECTION][CovidTracker::ResultKeys::REGION_ID]
        end

        def region_label_from_region_data(region_data)
          region_data.first[CovidTracker::ResultKeys::RESULT_SECTION][CovidTracker::ResultKeys::REGION_LABEL]
        end

        def default_last_day
          Qa::Authorities::Covid.most_recent_day_with_data
        end

        def dt_last_day(last_day)
          Date.strptime(last_day,"%F")
        end
    end
  end
end
