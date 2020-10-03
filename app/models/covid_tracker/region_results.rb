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

    delegate :code, :label, to: :region_registration, prefix: :region
  end
end
