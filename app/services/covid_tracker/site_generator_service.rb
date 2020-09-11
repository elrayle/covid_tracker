# frozen_string_literal: true

module CovidTracker
  class SiteGeneratorService
    class_attribute :registry_class, :data_service
    self.registry_class = CovidTracker::RegionRegistry
    self.data_service = CovidTracker::DataService

    THIS_WEEK = :this_week
    THIS_MONTH = :this_month
    SINCE_MARCH = :since_march

    ALL_REGIONS_LABEL = "All Regions"
    ALL_REGIONS_ID = "all_regions"

    # @param days [Integer] number of days of data to fetch
    # @return [Hash] full set of data for all configured regions - see example in class documentation
    class << self
      include CovidTracker::PageGeneratorService
      include CovidTracker::SidebarGeneratorService
      include CovidTracker::GraphGeneratorService

      def update_site
        registered_regions = registry_class.registry
        update_pages(registered_regions: registered_regions)
        update_sidebar(registered_regions: registered_regions)
        update_graphs(registered_regions: registered_regions)
      end

    private

      def last_updated
        dt = Time.now.in_time_zone(Qa::Authorities::Covid::DATA_TIME_ZONE)
        dt.strftime("%b %-d, %Y")
      end

      def page_file_name(id, time_period)
        "#{id}-#{time_period_short_form(time_period)}"
      end

      def all_regions_file_name(time_period)
        "all_regions-#{time_period_short_form(time_period)}"
      end

      def time_period_text(time_period)
        case time_period
        when THIS_WEEK
          "This Week"
        when THIS_MONTH
          "This Month"
        when SINCE_MARCH
          "Since March"
        end
      end

      def time_period_long_form(time_period)
        case time_period
        when THIS_WEEK
          "this_week"
        when THIS_MONTH
          "this_month"
        when SINCE_MARCH
          "since_march"
        end
      end

      def time_period_short_form(time_period)
        case time_period
        when THIS_WEEK
          "7_days"
        when THIS_MONTH
          "30_days"
        when SINCE_MARCH
          "since_march"
        end
      end

      def time_period_days(time_period)
        case time_period
        when THIS_WEEK
          7
        when THIS_MONTH
          30
        when SINCE_MARCH
          latest_dt = DateTime.now.in_time_zone("Eastern Time (US & Canada)") - 1.day
          march_01 = DateTime.strptime("03-01-2020 22:00:00 Eastern Time (US & Canada)", '%m-%d-%Y %H:%M:%S %Z')
          (latest_dt.to_date - march_01.to_date).to_i
        end
      end
    end
  end
end
