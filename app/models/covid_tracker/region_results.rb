module CovidTracker
  class RegionResults
    REGION_LABEL = CovidTracker::RegionKeys::REGION_LABEL
    REGION_DATA = CovidTracker::RegionKeys::REGION_DATA
    RESULT_SECTION = CovidTracker::ResultKeys::RESULT_SECTION
    REQUEST_SECTION = CovidTracker::RequestKeys::REQUEST_SECTION

    attr_accessor :region_id, :region_label, :region_data

    def append_data(request: response:)
      @region_data ||= []
      datum = { request: request, result: result }
      @region_data << datum
    end

    # @param raw_results [Hash] raw results to convert into a model for easy access
    # @example raw_results
    #   {
    #     "usa-new_york-cortland" => {
    #       region_label: "Cortland, New York, USA",
    #       region_data: [
    #         {
    #           result: {
    #             id: "2020-05-31_usa-new_york-cortland",
    #             label: "Cortland, New York, USA (2020-05-31)",
    #             region_id: "usa-new_york-cortland",
    #             region_label: "Cortland, New York, USA",
    #             date: "2020-05-31",
    #             cumulative_confirmed: 203,
    #             delta_confirmed: 3,
    #             cumulative_deaths: 5,
    #             delta_deaths: 0
    #           }
    #           request: {
    #             date: "2020-05-31",
    #             country_iso: "USA",
    #             province_state: "New York",
    #             admin2_county: "Cortland"
    #           }
    #         },
    #         ...     # more data for same region
    #       ]
    #     },
    #     ...    # next region
    #   }
    def region_results_for(raw_results)
      result_for(raw_request)
    end
  end
end
