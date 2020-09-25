module CovidTracker
  class RegionDatum
    RESULT_SECTION = CovidTracker::ResultKeys::RESULT_SECTION
    REQUEST_SECTION = CovidTracker::RequestKeys::REQUEST_SECTION

    attr_accessor :result, :request

    # @param raw_results [Hash] raw results as returned from CovidTracker::CovidApi to convert into a model for easy access
    # @see CovidTracker::CovidApi#find_for for full example of returned json hash
    # @example raw_results
    #   {
    #     result: { ... }
    #     request: { ... }
    #   }
    def self.for(raw_datum)
      CovidTracker::Result.for(raw_datum[RESULT_SECTION])
      CovidTracker::Request.for(raw_datum[REQUEST_SECTION])
    end
  end
end
