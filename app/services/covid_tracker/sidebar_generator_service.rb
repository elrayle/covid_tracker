# frozen_string_literal: true

module CovidTracker
  class SidebarGeneratorService # rubocop:disable Metrics/ClassLength
    class_attribute :registry_class, :time_period_service
    self.registry_class = CovidTracker::RegionRegistry
    self.time_period_service = CovidTracker::TimePeriodService

    SIDEBAR_FILE = File.join("docs", "_data", "sidebars", "home_sidebar.yml")

    THIS_WEEK = time_period_service::THIS_WEEK
    THIS_MONTH = time_period_service::THIS_MONTH
    SINCE_MARCH = time_period_service::SINCE_MARCH

    ALL_REGIONS_LABEL = CovidTracker::SiteGeneratorService::ALL_REGIONS_LABEL
    ALL_REGIONS_CODE = CovidTracker::SiteGeneratorService::ALL_REGIONS_CODE

    attr_reader :registered_regions # [Array<CovidTracker::RegionRegistration>]

    # @param area [CovidTracker::CentralAreaRegistration] generate sidebar for this area
    def initialize(area:)
      @registered_regions = area.regions
    end

    # Update sidebar for all time periods.
    def update_sidebar
      write_sidebar
      puts("Sidebar Generation Complete for #{registered_regions.count} regions!") # rubocop:disable Rails/Output
    end

  private

    def write_sidebar
      sidebar = generate_sidebar
      file = File.new(SIDEBAR_FILE, 'w')
      file << sidebar
      file.close
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
- title: Sidebar Menu
  folders:

"
    end

    def generate_time_period_section(time_period)
      body = generate_time_period_header(time_period)
      body += generate_time_period_page(ALL_REGIONS_LABEL, ALL_REGIONS_CODE, time_period)
      registered_regions.each do |registration|
        label = registration.label
        code = registration.code
        body += generate_time_period_page(label, code, time_period)
      end
      body
    end

    def generate_time_period_header(time_period)
      "  - title: #{time_period_service.text_form(time_period)}
    output: web, pdf
    folderitems:

"
    end

    def generate_time_period_page(label, code, time_period)
      "    - title: #{label}
      url: /#{CovidTracker::DailyPagesGeneratorService.page_file_name(code, time_period)}.html
      output: web, pdf

"
    end

    def generate_weekly_totals_section
      body = generate_weekly_totals_header
      body += generate_weekly_totals_page(ALL_REGIONS_LABEL, ALL_REGIONS_CODE)
      registered_regions.each do |registration|
        label = registration.label
        code = registration.code
        body += generate_weekly_totals_page(label, code)
      end
      body
    end

    def generate_weekly_totals_header
      "  - title: Weekly Totals
    output: web, pdf
    folderitems:

"
    end

    def generate_weekly_totals_page(label, code)
      "    - title: #{label}
      url: /#{CovidTracker::WeeklyPagesGeneratorService.page_file_name(code)}.html
      output: web, pdf

"
    end

    def generate_by_region_section
      body = generate_by_region_header
      registered_regions.each do |registration|
        label = registration.label
        code = registration.code
        body += generate_by_region_page(label, code)
      end
      body
    end

    def generate_by_region_header
      "  - title: By Region
    output: web, pdf
    folderitems:

"
    end

    def generate_by_region_page(label, code)
      "    - title: #{label}
      url: /#{CovidTracker::ByRegionPagesGeneratorService.page_file_name(code)}.html
      output: web, pdf

"
    end
  end
end
