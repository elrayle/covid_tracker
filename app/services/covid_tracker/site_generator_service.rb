# frozen_string_literal: true

module CovidTracker
  class SiteGeneratorService
    class_attribute :registry_class
    self.registry_class = CovidTracker::RegionRegistry

    ALL_REGIONS_LABEL = "All Regions"
    ALL_REGIONS_CODE = "all_regions"

    # @param days [Integer] number of days of data to fetch
    # @return [Hash] full set of data for all configured regions - see example in class documentation
    class << self
      def update_site
        registered_regions = registry_class.registry
        update_sidebar(registered_regions: registered_regions)
        update_daily_pages(registered_regions: registered_regions)
        update_weekly_pages(registered_regions: registered_regions)
        update_daily_graphs(registered_regions: registered_regions)
        update_weekly_graphs(registered_regions: registered_regions)
      end

      def update_sidebar(registered_regions: registry_class.registry)
        generator = CovidTracker::SidebarGeneratorService.new(registered_regions: registered_regions)
        generator.update_sidebar
      end

      def update_daily_pages(registered_regions: registry_class.registry)
        generator = CovidTracker::DailyPagesGeneratorService.new(registered_regions: registered_regions)
        generator.update_pages
      end

      def update_weekly_pages(registered_regions: registry_class.registry)
        generator = CovidTracker::WeeklyPagesGeneratorService.new(registered_regions: registered_regions)
        generator.update_pages
      end

      def update_daily_graphs(registered_regions: registry_class.registry)
        generator = CovidTracker::DailyGraphsGeneratorService.new(registered_regions: registered_regions)
        generator.update_graphs
      end

      def update_weekly_graphs(registered_regions: registry_class.registry)
        generator = CovidTracker::WeeklyGraphsGeneratorService.new(registered_regions: registered_regions)
        generator.update_graphs
      end
    end
  end
end
