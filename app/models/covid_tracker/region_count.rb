module CovidTracker
  class RegionCount < ApplicationRecord
    self.table_name = 'covid_tracker_region_counts'

    class_attribute :data_service
    self.data_service = CovidTracker::DataService

    belongs_to :region, class_name: "CovidTracker::Region", foreign_key: "region_id"

    def self.for(region_code:, region_datum:)
      region_count = new
      region_count.region_id = CovidTracker::Region.find_or_create_region_code_for(region_code: region_code)
      region_count.result_code = data_service.result_code(region_datum)
      region_count.result_label = data_service.result_label(region_datum)
      region_count.date = data_service.date(region_datum)
      region_count.cumulative_confirmed = data_service.cumulative_confirmed(region_datum)
      region_count.delta_confirmed = data_service.delta_confirmed(region_datum)
      region_count.cumulative_deaths = data_service.cumulative_deaths(region_datum)
      region_count.delta_deaths = data_service.delta_deaths(region_datum)
      region_count.save
      region_count
    end

    def self.find_by(region_code:, date: nil)
      region_id = CovidTracker::Region.find_or_create_region_code_for(region_code: region_code).id
      where_clause = { region_id: region_id }
      where_clause[:date] = date unless date.blank?
      where(where_clause)
    end
  end
end
