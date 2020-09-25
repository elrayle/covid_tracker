module CovidTracker
  class Request
    DATE = CovidTracker::RequestKeys::DATE
    COUNTRY_ISO = CovidTracker::RequestKeys::COUNTRY_ISO
    PROVINCE_STATE = CovidTracker::RequestKeys::PROVINCE_STATE
    ADMIN2_COUNTY = CovidTracker::RequestKeys::ADMIN2_COUNTY

    attr_accessor :date, :country_iso, :province_state, :admin2_county

    def country_iso?
      country_iso.present?
    end

    def province_state?
      province_state.present?
    end

    def admin2_county?
      admin2_county.present?
    end

    # @param raw_request [Hash] raw request to convert into a model for easy access
    # @see CovidTracker::CovidApi#find_for for full example of returned json hash
    # @example raw_request
    #   {
    #     date: "2020-05-31",
    #     country_iso: "USA",
    #     province_state: "New York",
    #     admin2_county: "Cortland"
    #   }
    def self.for(raw_request)
      request = CovidTracker::Request.new
      request.date = raw_request[DATE]
      request.country_iso = raw_request[COUNTRY_ISO] if raw_request.key? COUNTRY_ISO
      request.province_state = raw_request[PROVINCE_STATE] if raw_request.key? PROVINCE_STATE
      request.admin2_county = raw_request[ADMIN2_COUNTY] if raw_request.key? ADMIN2_COUNTY
      request
    end
  end
end
