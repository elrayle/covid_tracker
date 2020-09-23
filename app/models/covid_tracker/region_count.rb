module CovidTracker
  class RegionCount < ApplicationRecord
    self.table_name = 'covid_tracker_region_counts'

    class_attribute :data_service
    self.data_service = CovidTracker::DataService

    belongs_to :region, class_name: "CovidTracker::Region", foreign_key: "region_id"

    def initialize(region_code:, date:, response:)
      @region_id = CovidTracker::Region.find_or_create_region_code_for(region_code: region_code)
      @date = date
      @confirmed_cases = data_service.confirmed_cases(response)
      @delta_cases = data_service.delta_cases(response)
      @confirmed_deaths = data_service.confirmed_deaths(response)
      @delta_deaths = data_service.delta_deaths(response)
      save
byebug      
    end

    def self.find_by(region_code:, date: nil)
      region_id = CovidTracker::Region.find_or_create_region_code_for(region_code: region_code)
      where_clause = { region_id: region_id }
      where_clause[date] = date unless date.blank?
      where(where_clause)
    end
  end
end
