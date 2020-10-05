module CovidTracker
  class Result
    ERROR = CovidTracker::ResultKeys::ERROR
    RESULT_CODE = CovidTracker::ResultKeys::RESULT_CODE
    RESULT_LABEL = CovidTracker::ResultKeys::RESULT_LABEL
    DATE = CovidTracker::ResultKeys::DATE
    CUMULATIVE_CONFIRMED = CovidTracker::ResultKeys::CUMULATIVE_CONFIRMED
    DELTA_CONFIRMED = CovidTracker::ResultKeys::DELTA_CONFIRMED
    CUMULATIVE_DEATHS = CovidTracker::ResultKeys::CUMULATIVE_DEATHS
    DELTA_DEATHS = CovidTracker::ResultKeys::DELTA_DEATHS

    attr_accessor :id, :result_code, :result_label, :date, :cumulative_confirmed, :delta_confirmed, :cumulative_deaths, :delta_deaths, :error

    # @param raw_result [Hash] raw result to convert into a model for easy access
    # @see CovidTracker::CovidApi#find_for for full example of returned json hash
    # @example raw_result
    #   {
    #     result_code: "2020-05-31_usa-new_york-cortland",
    #     result_label: "Cortland, New York, USA (2020-05-31)",
    #     region_code: "usa-new_york-cortland",
    #     region_label: "Cortland, New York, USA",
    #     date: "2020-05-31",
    #     cumulative_confirmed: 203,
    #     delta_confirmed: 3,
    #     cumulative_deaths: 5,
    #     delta_deaths: 0
    #   }
    def self.for(raw_result)
      result = new
      result.error = raw_result[ERROR] if raw_result.key? ERROR
      return result if result.error?

      result.id = nil
      result.result_code = raw_result[RESULT_CODE]
      result.result_label = raw_result[RESULT_LABEL]
      result.date = raw_result[DATE]
      result.cumulative_confirmed = raw_result[CUMULATIVE_CONFIRMED]
      result.delta_confirmed = raw_result[DELTA_CONFIRMED]
      result.cumulative_deaths = raw_result[CUMULATIVE_DEATHS]
      result.delta_deaths = raw_result[DELTA_DEATHS]
      result
    end

    def self.parse_result(count_data:)
      result = new
      result.id = count_data.id
      result.result_code = count_data.result_code
      result.result_label = count_data.result_label
      result.date = count_data.date
      result.cumulative_confirmed = count_data.cumulative_confirmed
      result.delta_confirmed = count_data.delta_confirmed
      result.cumulative_deaths = count_data.cumulative_deaths
      result.delta_deaths = count_data.delta_deaths
      result
    end

    def error?
      error.present?
    end
  end
end
