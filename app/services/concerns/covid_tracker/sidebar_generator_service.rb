# frozen_string_literal: true

module CovidTracker
  module SidebarGeneratorService
    SIDEBAR_FILE = File.join("docs", "_data", "sidebars", "home_sidebar.yml")

    THIS_WEEK = CovidTracker::SiteGeneratorService::THIS_WEEK
    THIS_MONTH = CovidTracker::SiteGeneratorService::THIS_MONTH
    SINCE_MARCH = CovidTracker::SiteGeneratorService::SINCE_MARCH

    ALL_REGIONS_LABEL = CovidTracker::SiteGeneratorService::ALL_REGIONS_LABEL
    ALL_REGIONS_ID = CovidTracker::SiteGeneratorService::ALL_REGIONS_ID

    # Update sidebar for all time periods.
    # @param registered_regions [Array<CovidTracker::RegionRegistration>] registered regions
    def update_sidebar(registered_regions: registry_class.registry)
      write_sidebar(registered_regions)
      puts("Sidebar Generation Complete for #{registered_regions.count} regions!") # rubocop:disable Rails/Output
    end

  private

    def write_sidebar(registered_regions)
      sidebar = generate_sidebar(registered_regions)
      file = File.new(SIDEBAR_FILE, 'w')
      file << sidebar
      file.close
    end

    def generate_sidebar(registered_regions)
      sidebar = generate_sidebar_header
      sidebar += generate_time_period_section(registered_regions, THIS_WEEK)
      sidebar += generate_time_period_section(registered_regions, THIS_MONTH)
      sidebar += generate_time_period_section(registered_regions, SINCE_MARCH)
      sidebar
    end

    def generate_sidebar_header
      "entries:
- title: Sidebar Menu
  folders:

"
    end

    def generate_time_period_section(registered_regions, time_period)
      body = generate_time_period_header(time_period)
      body += generate_time_period_page(ALL_REGIONS_LABEL, ALL_REGIONS_ID, time_period)
      registered_regions.each do |registration|
        label = registration.label
        id = registration.id
        body += generate_time_period_page(label, id, time_period)
      end
      body
    end

    def generate_time_period_header(time_period)
      "  - title: #{time_period_text(time_period)}
    output: web, pdf
    folderitems:

"
    end

    def generate_time_period_page(label, id, time_period)
      "    - title: #{label}
      url: /#{page_file_name(id, time_period)}.html
      output: web, pdf

"
    end
  end
end
