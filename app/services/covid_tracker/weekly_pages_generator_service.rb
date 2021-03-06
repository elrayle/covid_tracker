# frozen_string_literal: true

module CovidTracker
  class WeeklyPagesGeneratorService # rubocop:disable Metrics/ClassLength
    class_attribute :time_period_service, :file_service
    self.time_period_service = CovidTracker::TimePeriodService
    self.file_service = CovidTracker::FileService

    TAIL_DIRECTORY = "weekly_totals"
    FILE_POSTFIX = "-weekly_totals"
    KEYWORDS = "weekly totals"

    THIS_WEEK = time_period_service::THIS_WEEK
    THIS_MONTH = time_period_service::THIS_MONTH
    SINCE_MARCH = time_period_service::SINCE_MARCH

    ALL_REGIONS_LABEL = CovidTracker::SiteGeneratorService::ALL_REGIONS_LABEL
    ALL_REGIONS_CODE = CovidTracker::SiteGeneratorService::ALL_REGIONS_CODE

    attr_reader :central_area # CovidTracker::CentralAreaRegistration

    class << self
      # @option central_area_code [String] code for the central area (e.g. 'usa-georgia-richmond')
      # @param region_code [String] code for a region near the central area (e.g. 'all_regions', 'usa-georgia-columbia')
      # @returns [String] perma_link identifying path page in _site (e.g. 'usa-georgia-richmond/weekly_totals')
      def perma_link(central_area_code:, region_code:, include_app_dir: false)
        target_file_parts ||= file_parts(central_area_code: central_area_code,
                                         region_code: region_code,
                                         file_type: file_service::PAGE_TARGET_FILE_TYPE,
                                         include_app_dir: include_app_dir)
        file_service.perma_link(target_file_parts)
      end

    private

      def file_parts(central_area_code:, region_code:, file_type:, include_app_dir: false)
        parts = {}
        parts[:file_type] = file_type
        parts[:central_area_code] = central_area_code
        parts[:region_code] = region_code
        parts[:tail_directory] = TAIL_DIRECTORY
        parts[:file_postfix] = FILE_POSTFIX
        parts[:include_app_dir] = include_app_dir
        parts
      end
    end

    # @param area [CovidTracker::CentralAreaRegistration] generate weekly pages for this area
    def initialize(area:)
      @central_area = area
    end

    # Update all pages for all time periods.
    def update_pages
      update_region_pages
      update_all_regions_pages
      puts("Weekly Page Generation Complete for #{central_area.regions.count} regions in area #{central_area.label}!") # rubocop:disable Rails/Output
    end

  private

    def update_region_pages
      central_area.regions.each do |region_registration|
        write_page(region_registration)
      end
    end

    def update_all_regions_pages
      write_all_regions_page
    end

    def write_page(region_registration)
      source_file_parts = self.class.send(:file_parts, central_area_code: central_area.code,
                                                       region_code: region_registration.code,
                                                       file_type: file_service::PAGE_SOURCE_FILE_TYPE)
      page = generate_page(region_registration)
      file_service.write_to_file(source_file_parts, page)
    end

    def write_all_regions_page
      source_file_parts = self.class.send(:file_parts, central_area_code: central_area.code,
                                                       region_code: ALL_REGIONS_CODE,
                                                       file_type: file_service::PAGE_SOURCE_FILE_TYPE)
      page = generate_all_regions_page
      file_service.write_to_file(source_file_parts, page)
    end

    def generate_page(region_registration)
      region_label = region_registration.label
      region_code = region_registration.code
      front_matter = generate_front_matter(region_label, region_code)
      body = generate_body(region_label, region_code)
      front_matter + body
    end

    def generate_all_regions_page
      front_matter = generate_front_matter(ALL_REGIONS_LABEL, ALL_REGIONS_CODE)
      body = ""
      central_area.regions.each do |region_registration|
        region_label = region_registration.label
        region_code = region_registration.code
        body += "\n<h3>#{region_label}</h3>\n"
        body += generate_body(region_label, region_code)
      end
      front_matter + body
    end

    def generate_front_matter(region_label, region_code)
      "---
title: #{region_label}
permalink: /#{self.class.perma_link(central_area_code: central_area.code, region_code: region_code)}
last_updated: #{time_period_service.today_str}
keywords: [\"#{region_label}\", \"#{KEYWORDS}\"]
sidebar: #{central_area.code}_sidebar
---
"
    end

    def generate_body(region_label, region_code)
      "
![#{graph_alttext(region_label)}](#{graph_path(region_code)})
"
    end

    def graph_alttext(region_label)
      "Weekly Totals of Confirmed Cases for #{region_label}"
    end

    def graph_path(region_code)
      "#{app_dir}/images/graphs/#{region_code}#{FILE_POSTFIX}_graph.png"
    end

    def app_dir
      return "" if CovidTracker::SiteGeneratorService.local_testing?
      "/#{CovidTracker::SiteGeneratorService.app_dir}"
    end
  end
end
