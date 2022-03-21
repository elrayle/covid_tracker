# frozen_string_literal: true

module CovidTracker
  class DailyPagesGeneratorService # rubocop:disable Metrics/ClassLength
    class_attribute :time_period_service, :file_service
    self.time_period_service = CovidTracker::TimePeriodService
    self.file_service = CovidTracker::FileService

    THIS_WEEK = time_period_service::THIS_WEEK
    THIS_MONTH = time_period_service::THIS_MONTH

    ALL_REGIONS_LABEL = CovidTracker::SiteGeneratorService::ALL_REGIONS_LABEL
    ALL_REGIONS_CODE = CovidTracker::SiteGeneratorService::ALL_REGIONS_CODE

    attr_reader :central_area # CovidTracker::CentralAreaRegistration

    class << self
      # @option central_area_code [String] code for the central area (e.g. 'usa-georgia-richmond')
      # @param region_code [String] code for a region near the central area (e.g. 'all_regions', 'usa-georgia-columbia')
      # @param time_period [Symbol] the time period covered by the page (e.g. THIS_WEEK, THIS_MONTH)
      # @returns [String] perma_link for page in _site (e.g. 'covid_tracker/usa-georgia-richmond/this_week')
      def perma_link(central_area_code:, region_code:, time_period:, include_app_dir: false)
        target_file_parts ||= file_parts(central_area_code: central_area_code,
                                         region_code: region_code,
                                         file_type: file_service::PAGE_TARGET_FILE_TYPE,
                                         time_period: time_period,
                                         include_app_dir: include_app_dir)
        file_service.perma_link(target_file_parts)
      end

    private

      def file_parts(central_area_code:, region_code:, file_type:, time_period:, include_app_dir: false)
        parts = {}
        parts[:file_type] = file_type
        parts[:central_area_code] = central_area_code
        parts[:region_code] = region_code
        parts[:tail_directory] = time_period_service.long_form(time_period)
        parts[:file_postfix] = "-#{time_period_service.short_form(time_period)}"
        parts[:include_app_dir] = include_app_dir
        parts
      end
    end

    # @param area [CovidTracker::CentralAreaRegistration] generate time period pages for this area
    def initialize(area:)
      @central_area = area
    end

    # Update all pages for all time periods.
    def update_pages
      update_region_pages
      update_all_regions_pages
      puts("Daily Page Generation Complete for #{central_area.regions.count} regions in area #{central_area.label}!") # rubocop:disable Rails/Output
    end

  private

    def update_region_pages
      central_area.regions.each do |region_registration|
        write_page(region_registration, THIS_WEEK)
        write_page(region_registration, THIS_MONTH)
      end
    end

    def update_all_regions_pages
      write_all_regions_page(THIS_WEEK)
      write_all_regions_page(THIS_MONTH)
    end

    def write_page(region_registration, time_period)
      source_file_parts = self.class.send(:file_parts, central_area_code: central_area.code,
                                                       region_code: region_registration.code,
                                                       time_period: time_period,
                                                       file_type: file_service::PAGE_SOURCE_FILE_TYPE)
      page = generate_page(region_registration, time_period)
      file_service.write_to_file(source_file_parts, page)
    end

    def write_all_regions_page(time_period)
      source_file_parts = self.class.send(:file_parts, central_area_code: central_area.code,
                                                       region_code: ALL_REGIONS_CODE,
                                                       time_period: time_period,
                                                       file_type: file_service::PAGE_SOURCE_FILE_TYPE)
      page = generate_all_regions_page(time_period)
      file_service.write_to_file(source_file_parts, page)
    end

    def generate_page(region_registration, time_period)
      region_label = region_registration.label
      region_code = region_registration.code
      front_matter = generate_front_matter(region_label, region_code, time_period)
      body = generate_body(region_label, region_code, time_period)
      front_matter + body
    end

    def generate_all_regions_page(time_period)
      front_matter = generate_front_matter(ALL_REGIONS_LABEL, ALL_REGIONS_CODE, time_period)
      body = ""
      central_area.regions.each do |region_registration|
        region_label = region_registration.label
        region_code = region_registration.code
        body += "\n<h3>#{region_label}</h3>\n"
        body += generate_body(region_label, region_code, time_period)
      end
      front_matter + body
    end

    def generate_front_matter(region_label, region_code, time_period)
      "---
title: #{region_label}
permalink: /#{self.class.perma_link(central_area_code: central_area.code, region_code: region_code, time_period: time_period)}
last_updated: #{time_period_service.today_str}
keywords: [\"#{region_label}\", \"#{time_period_service.text_form(time_period)}\"]
sidebar: #{central_area.code}_sidebar
---
"
    end

    def generate_body(region_label, region_code, time_period)
      "
![#{graph_alttext(region_label, time_period, 'Confirmed Cases')}](#{graph_path(region_code, time_period, 'delta_confirmed')})

![#{graph_alttext(region_label, time_period, 'Confirmed Deaths')}](#{graph_path(region_code, time_period, 'delta_deaths')})
"
    end

    def graph_alttext(region_label, time_period, stat_label)
      "Change in #{stat_label} #{time_period_service.text_form(time_period)} for #{region_label}"
    end

    def graph_path(region_code, time_period, stat_code)
      "#{app_dir}/images/graphs/#{region_code}-#{stat_code}-#{time_period_service.short_form(time_period)}_graph.png"
    end

    def app_dir
      return "" if CovidTracker::SiteGeneratorService.local_testing?
      "/#{CovidTracker::SiteGeneratorService.app_dir}"
    end
  end
end
