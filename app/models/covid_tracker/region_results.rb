module CovidTracker
  class RegionResults
    attr_accessor :region_registration, :region_data

    # @param region_registration [CovidTracker::RegionRegistration] registration for the region
    # @param region_data [Array<CovidTracker::RegionDatum>] data for a region during a range of dates
    # @returns [CovidTracker::RegionResults] instance of this class
    def initialize(region_registration:, region_data:)
      @region_registration = region_registration
      @region_data = region_data
    end

    def region_code
      region_registration.region_code
    end

    def region_label
      region_registration.region_label
    end
  end
end
