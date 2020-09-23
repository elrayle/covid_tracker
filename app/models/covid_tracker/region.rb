module CovidTracker
  class Region < ApplicationRecord
    self.table_name = 'covid_tracker_regions'

    has_many :region_counts, dependent: :delete_all

    def self.find_or_create_region_code_for(region_code:)
      region = where(region_code: region_code)
      return region.first.id unless region.empty?
      new_region = Region.new(region_code: region_code)
      new_region.save
      new_region.id
    end

  end
end
