# frozen_string_literal: true

module CovidTracker
  class SidebarconfigsGeneratorService
    class_attribute :file_service
    self.file_service = CovidTracker::FileService

    attr_reader :central_areas

    # @param areas [Array<CovidTracker::CentralAreaRegistration>] generate sidebarconfigs for all areas
    def initialize(areas:)
      @central_areas = areas
    end

    # Update sidebar for all time periods.
    def update_sidebarconfigs
      write_sidebarconfigs
      puts("Sidebarconfigs Generation Complete for #{central_areas.count} areas!") # rubocop:disable Rails/Output
    end

  private

    def file_parts
      parts = {}
      parts[:file_type] = file_service::SIDEBARCONFIGS_FILE_TYPE
      parts
    end

    def write_sidebarconfigs
      sidebarconfigs = generate_sidebarconfigs
      file_service.write_to_file(file_parts, sidebarconfigs)
    end

    def generate_sidebarconfigs
      sidebarconfigs = generate_sidebarconfig_header
      central_areas.each { |area| sidebarconfigs += generate_sidebarconfig_for(cental_area: area) }
      sidebarconfigs += generate_sidebarconfig_default
      sidebarconfigs
    end

    def generate_sidebarconfig_header
      # home_sidebar isn't used.  Leaving it in to make generation easier.
      "{% if page.sidebar == \"home_sidebar\" %}
{% assign sidebar = site.data.sidebars.home_sidebar.entries %}
"
    end

    def generate_sidebarconfig_for(cental_area:)
      "
{% elsif page.sidebar == \"#{cental_area.code}_sidebar\" %}
{% assign sidebar = site.data.sidebars.#{cental_area.code}_sidebar.entries %}
"
    end

    def generate_sidebarconfig_default
      # home_sidebar isn't used.  Leaving it in to make generation easier.
      "
{% else %}
{% assign sidebar = site.data.sidebars.home_sidebar.entries %}
{% endif %}
"
    end
  end
end
