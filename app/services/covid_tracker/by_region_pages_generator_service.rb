# frozen_string_literal: true

module CovidTracker
  class ByRegionPagesGeneratorService
    class_attribute :time_period_service, :file_service
    self.time_period_service = CovidTracker::TimePeriodService
    self.file_service = CovidTracker::FileService

    TAIL_DIRECTORY = "by_region"
    FILE_POSTFIX = "-by_region"
    KEYWORDS = "by region"

    THIS_WEEK = time_period_service::THIS_WEEK
    THIS_MONTH = time_period_service::THIS_MONTH
    THIS_YEAR = time_period_service::THIS_YEAR
    SINCE_MARCH = time_period_service::SINCE_MARCH

    attr_reader :central_area # CovidTracker::CentralAreaRegistration

    class << self
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

    # @param area [CovidTracker::CentralAreaRegistration] generate region pages for this area
    def initialize(area:)
      @central_area = area
    end

    # Update all pages for all regions.
    def update_pages
      update_region_pages
      puts("By Region Page Generation Complete for #{central_area.regions.count} regions in area #{central_area.label}!") # rubocop:disable Rails/Output
    end

  private

    def update_region_pages
      central_area.regions.each do |region_registration|
        write_page(region_registration)
      end
    end

    def write_page(region_registration)
      source_file_parts = self.class.send(:file_parts, central_area_code: central_area.code,
                                                       region_code: region_registration.code,
                                                       file_type: file_service::PAGE_SOURCE_FILE_TYPE)
      page = generate_page(region_registration)
      file_service.write_to_file(source_file_parts, page)
    end

    def generate_page(region_registration)
      region_label = region_registration.label
      region_code = region_registration.code
      front_matter = generate_front_matter(region_label, region_code)
      body = generate_body(region_label, region_code)
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
<h3>Last 365 Days</h3>

![#{graph_weekly_alttext(region_label)}](#{graph_weekly_path(region_code)})

<h3>Last 30 Days</h3>

![#{graph_time_alttext(region_label, THIS_MONTH, 'Confirmed Cases')}](#{graph_time_path(region_code, THIS_MONTH, 'delta_confirmed')})

![#{graph_time_alttext(region_label, THIS_MONTH, 'Confirmed Deaths')}](#{graph_time_path(region_code, THIS_MONTH, 'delta_deaths')})

<h3>Last 7 Days</h3>

![#{graph_time_alttext(region_label, THIS_WEEK, 'Confirmed Cases')}](#{graph_time_path(region_code, THIS_WEEK, 'delta_confirmed')})

![#{graph_time_alttext(region_label, THIS_WEEK, 'Confirmed Deaths')}](#{graph_time_path(region_code, THIS_WEEK, 'delta_deaths')})

<h3>Since Beginning</h3>

![#{graph_time_alttext(region_label, SINCE_MARCH, 'Confirmed Cases')}](#{graph_time_path(region_code, SINCE_MARCH, 'delta_confirmed')})

![#{graph_time_alttext(region_label, SINCE_MARCH, 'Confirmed Deaths')}](#{graph_time_path(region_code, SINCE_MARCH, 'delta_deaths')})
"
    end

    def graph_weekly_alttext(region_label)
      "Rolling 7-day Confirmed Cases last 365 days for #{region_label}"
    end

    def graph_weekly_path(region_code)
      "#{app_dir}/images/graphs/#{region_code}#{CovidTracker::WeeklyPagesGeneratorService::FILE_POSTFIX}_graph.png"
    end

    def graph_time_alttext(region_label, time_period, stat_label)
      "Change in #{stat_label} #{time_period_service.text_form(time_period)} for #{region_label}"
    end

    def graph_time_path(region_code, time_period, stat_code)
      "#{app_dir}/images/graphs/#{region_code}-#{stat_code}-#{time_period_service.short_form(time_period)}_graph.png"
    end

    def app_dir
      return "" if CovidTracker::SiteGeneratorService.local_testing?
      "/#{CovidTracker::SiteGeneratorService.app_dir}"
    end
  end
end
