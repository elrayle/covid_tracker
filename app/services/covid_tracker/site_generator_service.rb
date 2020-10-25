# frozen_string_literal: true

module CovidTracker
  class SiteGeneratorService
    class_attribute :registry_class, :central_area_registry
    self.registry_class = CovidTracker::CentralAreaRegistry
    self.central_area_registry = CovidTracker::CentralAreaRegistry

    ALL_REGIONS_LABEL = "All Regions"
    ALL_REGIONS_CODE = "all_regions"

    class << self
      def update_site
        update_sidebar
        update_homepages
        update_daily_pages
        update_weekly_pages
        update_by_region_pages
        update_daily_graphs
        update_weekly_graphs
      end

      def local_testing?
        ENV.fetch('LOCAL_TESTING', false) == 'true' ? true : false
      end

      # Get app directory
      def app_dir
        @app_dir ||= Dir.pwd.split(File::SEPARATOR)[-1]
      end

      # @param central_area_code [String] code for the area to generate; all areas if nil
      def update_sidebar(central_area_code: nil)
        areas = areas(central_area_code)
        areas.each { |area| CovidTracker::SidebarGeneratorService.new(area: area).update_sidebar }
        CovidTracker::SidebarconfigsGeneratorService.new(areas: areas).update_sidebarconfigs
      end

      def update_homepages(central_area_code: nil)
        areas = areas(central_area_code)
        CovidTracker::SiteHomepageGeneratorService.new(areas: areas).update_homepage
        CovidTracker::CentralAreaHomepageGeneratorService.new(areas: areas).update_homepages
      end

      def update_daily_pages(central_area_code: nil)
        areas = areas(central_area_code)
        areas.each { |area| CovidTracker::DailyPagesGeneratorService.new(area: area).update_pages }
      end

      def update_weekly_pages(central_area_code: nil)
        areas = areas(central_area_code)
        areas.each { |area| CovidTracker::WeeklyPagesGeneratorService.new(area: area).update_pages }
      end

      def update_by_region_pages(central_area_code: nil)
        areas = areas(central_area_code)
        areas.each { |area| CovidTracker::ByRegionPagesGeneratorService.new(area: area).update_pages }
      end

      def update_daily_graphs(central_area_code: nil)
        areas = areas(central_area_code)
        areas.each { |area| CovidTracker::DailyGraphsGeneratorService.new(area: area).update_graphs }
      end

      def update_weekly_graphs(central_area_code: nil)
        areas = areas(central_area_code)
        areas.each { |area| CovidTracker::WeeklyGraphsGeneratorService.new(area: area).update_graphs }
      end

    private

      def areas(central_area_code)
        return central_area_registry.areas if central_area_code.blank?
        [central_area_registry.find_by(code: central_area_code)]
      end
    end
  end
end
