module CovidTracker
  class RegionDatum
    RESULT_SECTION = CovidTracker::ResultKeys::RESULT_SECTION
    REQUEST_SECTION = CovidTracker::RequestKeys::REQUEST_SECTION

    attr_accessor :result, :request

    delegate :error?, to: :result

    # @param raw_results [Hash] raw results as returned from CovidTracker::CovidApi to convert into a model for easy access
    # @see CovidTracker::CovidApi#find_for for full example of returned json hash
    # @example raw_results
    #   {
    #     result: { ... }
    #     request: { ... }
    #   }
    def self.for(raw_datum)
      datum = new
      datum.result = CovidTracker::Result.for(raw_datum[RESULT_SECTION])
      datum.request = CovidTracker::Request.for(raw_datum[REQUEST_SECTION])
      datum
    end

    def self.parse_datum(region_registration:, count_data:)
      datum = new
      datum.result = CovidTracker::Result.parse_result(count_data: count_data)
      datum.request = CovidTracker::Request.parse_request(region_registration: region_registration, date: count_data.date)
      datum
    end
  end
end
