# frozen_string_literal: true

module CovidTracker
  class SiteGeneratorService
    class_attribute :registry_class, :data_service, :data_retrieval_service, :graph_service, :time_period_service
    self.registry_class = CovidTracker::RegionRegistry
    self.data_service = CovidTracker::DataService
    self.data_retrieval_service = CovidTracker::DataRetrievalService
    self.graph_service = CovidTracker::GruffGraphService
    self.time_period_service = CovidTracker::TimePeriodService

    THIS_WEEK = time_period_service::THIS_WEEK
    THIS_MONTH = time_period_service::THIS_MONTH
    SINCE_MARCH = time_period_service::SINCE_MARCH

    ALL_REGIONS_LABEL = "All Regions"
    ALL_REGIONS_CODE = "all_regions"

    # @param days [Integer] number of days of data to fetch
    # @return [Hash] full set of data for all configured regions - see example in class documentation
    class << self
      include CovidTracker::PagesGeneratorService
      include CovidTracker::SidebarGeneratorService
      include CovidTracker::GraphDataService
      include CovidTracker::DailyGraphsGeneratorService
      include CovidTracker::WeeklyGraphsGeneratorService

      def update_site
        registered_regions = registry_class.registry
        update_pages(registered_regions: registered_regions)
        update_sidebar(registered_regions: registered_regions)
        update_daily_graphs(registered_regions: registered_regions)
        update_weekly_graphs(registered_regions: registered_regions)
      end
    end
  end
end
