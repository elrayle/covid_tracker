module CovidTracker
  class Region < ApplicationRecord
    self.table_name = 'covid_tracker_regions'

    has_many :region_counts, dependent: :delete_all

    # @param region_code [String] region code (e.g. "usa-alabama-wilcox")
    # @returns [CovidTracker::Region] instance of this class from covid_tracker_regions database table; creates if not found
    def self.find_or_create_region_code_for(region_code:)
      region = where(region_code: region_code)
      return region.first unless region.empty?
      new_region = Region.new(region_code: region_code)
      new_region.save
      new_region
    end
  end
end
