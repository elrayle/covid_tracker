module CovidTracker
  class Result
    ID = CovidTracker::ResultKeys::ID
    LABEL = CovidTracker::ResultKeys::LABEL
    DATE = CovidTracker::ResultKeys::DATE
    CUMULATIVE_CONFIRMED = CovidTracker::ResultKeys::CUMULATIVE_CONFIRMED
    DELTA_CONFIRMED = CovidTracker::ResultKeys::DELTA_CONFIRMED
    CUMULATIVE_DEATHS = CovidTracker::ResultKeys::CUMULATIVE_DEATHS
    DELTA_DEATHS = CovidTracker::ResultKeys::DELTA_DEATHS

    attr_accessor :id, :label, :date, :cumulative_confirmed, :delta_confirmed, :cumulative_deaths, :delta_deaths


    # @param raw_result [Hash] raw result to convert into a model for easy access
    # @example raw_result
    #   {
    #     id: "2020-05-31_usa-new_york-cortland",
    #     label: "Cortland, New York, USA (2020-05-31)",
    #     region_id: "usa-new_york-cortland",
    #     region_label: "Cortland, New York, USA",
    #     date: "2020-05-31",
    #     cumulative_confirmed: 203,
    #     delta_confirmed: 3,
    #     cumulative_deaths: 5,
    #     delta_deaths: 0
    #   }
    def result_for(raw_result)
      @id = raw_result[ID]
      @label = raw_result[LABEL]
      @date = raw_result[DATE]
      @cumulative_confirmed = raw_result[CUMULATIVE_CONFIRMED]
      @delta_confirmed = raw_result[DELTA_CONFIRMED]
      @cumulative_deaths = raw_result[CUMULATIVE_DEATHS]
      @delta_deaths = raw_result[DELTA_DEATHS]
    end  
  end
end
