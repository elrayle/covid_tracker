module CovidTracker
  class RegionCount < ApplicationRecord
    self.table_name = 'covid_tracker_region_counts'

    belongs_to :region, class_name: "CovidTracker::Region", foreign_key: "region_id"

    def self.find_by(region_code:, date: nil)
      region_id = CovidTracker::Region.find_or_create_region_code_for(region_code: region_code)
      where_clause = { region_id: region_id }
      where_clause[date] = date unless date.blank?
      where(where_clause)
    end
  end
end
