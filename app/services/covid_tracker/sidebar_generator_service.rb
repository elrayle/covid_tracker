# frozen_string_literal: true

module CovidTracker
  class SidebarGeneratorService # rubocop:disable Metrics/ClassLength
    class_attribute :time_period_service, :file_service
    self.time_period_service = CovidTracker::TimePeriodService
    self.file_service = CovidTracker::FileService

    FILE_POSTFIX = "_sidebar"

    THIS_WEEK = time_period_service::THIS_WEEK
    THIS_MONTH = time_period_service::THIS_MONTH
    SINCE_MARCH = time_period_service::SINCE_MARCH

    ALL_REGIONS_LABEL = CovidTracker::SiteGeneratorService::ALL_REGIONS_LABEL
    ALL_REGIONS_CODE = CovidTracker::SiteGeneratorService::ALL_REGIONS_CODE

    attr_reader :central_area

    class << self
      # @option central_area_code [String] code for the central area (e.g. 'usa-georgia-richmond')
      # @returns [String] perma_link identifying path page in _site (e.g. 'usa-georgia-richmond/weekly_totals')
      def perma_link(central_area_code:)
        file_parts = file_parts(central_area_code: central_area_code)
        file_service.perma_link(file_parts)
      end

    private

      def file_parts(central_area_code:)
        parts = {}
        parts[:file_type] = file_service::SIDEBAR_FILE_TYPE
        parts[:central_area_code] = central_area_code
        parts[:file_postfix] = FILE_POSTFIX
        parts
      end
    end

    # @param area [CovidTracker::CentralAreaRegistration] generate sidebar for this area
    def initialize(area:)
      @central_area = area
    end

    # Update sidebar for all time periods.
    def update_sidebar
      write_sidebar
      puts("Sidebar Generation Complete for #{central_area.regions.count} regions in area #{central_area.label}!") # rubocop:disable Rails/Output
    end

  private

    def write_sidebar
      file_parts = self.class.send(:file_parts, central_area_code: central_area.code)
      sidebar = generate_sidebar
      file_service.write_to_file(file_parts, sidebar)
    end

    def generate_sidebar
      sidebar = generate_sidebar_header
      sidebar += generate_weekly_totals_section
      sidebar += generate_time_period_section(THIS_MONTH)
      sidebar += generate_time_period_section(THIS_WEEK)
      sidebar += generate_time_period_section(SINCE_MARCH)
      sidebar += generate_by_region_section
      sidebar
    end

    def generate_sidebar_header
      "entries:
- title: #{central_area.sidebar_label}
  area_url: \"#{central_area.code}\"
  folders:

"
    end

    def generate_time_period_section(time_period)
      body = generate_time_period_header(time_period)
      body += generate_time_period_page(ALL_REGIONS_LABEL, ALL_REGIONS_CODE, time_period)
      central_area.regions.each do |region|
        region_label = region.label
        region_code = region.code
        body += generate_time_period_page(region_label, region_code, time_period)
      end
      body
    end

    def generate_time_period_header(time_period)
      "  - title: #{time_period_service.text_form(time_period)}
    output: web, pdf
    folderitems:

"
    end

    def generate_time_period_page(region_label, region_code, time_period)
      "    - title: #{region_label}
      url: \"/#{CovidTracker::DailyPagesGeneratorService.perma_link(central_area_code: central_area.code, region_code: region_code, time_period: time_period, include_app_dir: include_app_dir?)}\"
      output: web, pdf

"
    end

    def generate_weekly_totals_section
      body = generate_weekly_totals_header
      body += generate_weekly_totals_page(ALL_REGIONS_LABEL, ALL_REGIONS_CODE)
      central_area.regions.each do |region|
        region_label = region.label
        region_code = region.code
        body += generate_weekly_totals_page(region_label, region_code)
      end
      body
    end

    def generate_weekly_totals_header
      "  - title: Weekly Totals
    output: web, pdf
    folderitems:

"
    end

    def generate_weekly_totals_page(region_label, region_code)
      "    - title: #{region_label}
      url: \"/#{CovidTracker::WeeklyPagesGeneratorService.perma_link(central_area_code: central_area.code, region_code: region_code, include_app_dir: include_app_dir?)}\"
      output: web, pdf

"
    end

    def generate_by_region_section
      body = generate_by_region_header
      central_area.regions.each do |region|
        region_label = region.label
        region_code = region.code
        body += generate_by_region_page(region_label, region_code)
      end
      body
    end

    def generate_by_region_header
      "  - title: By Region
    output: web, pdf
    folderitems:

"
    end

    def generate_by_region_page(region_label, region_code)
      "    - title: #{region_label}
      url: \"/#{CovidTracker::ByRegionPagesGeneratorService.perma_link(central_area_code: central_area.code, region_code: region_code, include_app_dir: include_app_dir?)}\"
      output: web, pdf

"
    end

    def include_app_dir?
      !CovidTracker::SiteGeneratorService.local_testing?
    end
  end
end
