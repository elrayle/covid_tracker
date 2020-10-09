# frozen_string_literal: true

module CovidTracker
  class SidebarGeneratorService
    class_attribute :registry_class, :time_period_service
    self.registry_class = CovidTracker::RegionRegistry
    self.time_period_service = CovidTracker::TimePeriodService

    SIDEBAR_FILE = File.join("docs", "_data", "sidebars", "home_sidebar.yml")

    THIS_WEEK = time_period_service::THIS_WEEK
    THIS_MONTH = time_period_service::THIS_MONTH
    SINCE_MARCH = time_period_service::SINCE_MARCH

    ALL_REGIONS_LABEL = CovidTracker::SiteGeneratorService::ALL_REGIONS_LABEL
    ALL_REGIONS_CODE = CovidTracker::SiteGeneratorService::ALL_REGIONS_CODE

    attr_reader :registered_regions

    # @param registered_regions [Array<CovidTracker::RegionRegistration>] registered regions
    def initialize(registered_regions: registry_class.registry)
      @registered_regions = registered_regions
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
      sidebar += generate_time_period_section(THIS_WEEK)
      sidebar += generate_time_period_section(THIS_MONTH)
      sidebar += generate_time_period_section(SINCE_MARCH)
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
      url: /#{CovidTracker::PagesGeneratorService.page_file_name(code, time_period)}.html
      output: web, pdf

"
    end
  end
end
