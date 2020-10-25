# frozen_string_literal: true

module CovidTracker
  class SiteHomepageGeneratorService
    class_attribute :file_service
    self.file_service = CovidTracker::FileService

    attr_reader :central_areas

    # @param areas [Array<CovidTracker::CentralAreaRegistration>] generate homepages for all areas
    def initialize(areas:)
      @central_areas = areas
    end

    # Update sidebar for all time periods.
    def update_homepage
      write_homepage
      puts("Site Homepage Generation Complete for #{central_areas.count} areas!") # rubocop:disable Rails/Output
    end

  private

    def file_parts
      parts = {}
      parts[:file_type] = file_service::SITE_HOMEPAGE_FILE_TYPE
      parts
    end

    def write_homepage
      homepage = generate_homepage
      file_service.write_to_file(file_parts, homepage)
    end

    def generate_homepage
      homepage = generate_header
      central_areas.each { |area| homepage += generate_link_for(central_area: area) }
      homepage
    end

    def generate_header
      "---
layout: area_list
title: Covid Tracker Central Areas
permalink: index.html
toc: false
---

"
    end

    def generate_link_for(central_area:)
      "<p><a href=\"#{central_area.code}.html\">#{central_area.homepage_title}</a></p>
"
    end
  end
end
