# frozen_string_literal: true

module CovidTracker
  class CentralAreaHomepageGeneratorService
    class_attribute :file_service
    self.file_service = CovidTracker::FileService

    attr_reader :central_areas

    # @param areas [Array<CovidTracker::CentralAreaRegistration>] generate homepages for all areas
    def initialize(areas:)
      @central_areas = areas
    end

    # Update sidebar for all time periods.
    def update_homepages
      central_areas.each { |area| write_homepage(area) }
      puts("Homepage Generation Complete for #{central_areas.count} areas!") # rubocop:disable Rails/Output
    end

  private

    def file_parts(central_area)
      parts = {}
      parts[:file_type] = file_service::AREA_HOMEPAGE_FILE_TYPE
      parts[:central_area_code] = central_area.code
      parts
    end

    def write_homepage(area)
      homepage = generate_homepage(area)
      file_service.write_to_file(file_parts(area), homepage)
    end

    def generate_homepage(central_area)
      "---
layout: area_homepage
title: #{central_area.homepage_title}
central_area_code: #{central_area.code}
keywords: [#{keywords(central_area)}]
sidebar: #{central_area.code}_sidebar
permalink: #{central_area.code}.html
toc: false
---

"
    end

    def keywords(central_area)
      keywords = ""
      keywords += "\"#{central_area.country_iso}\""
      keywords += ", \"#{central_area.province_state}\"" if central_area.province_state.present?
      keywords += ", \"#{central_area.admin2_county}\"" if central_area.admin2_county.present?
      keywords
    end
  end
end
