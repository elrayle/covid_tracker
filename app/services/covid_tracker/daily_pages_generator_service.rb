# frozen_string_literal: true

module CovidTracker
  class DailyPagesGeneratorService
    class_attribute :registry_class, :time_period_service
    self.registry_class = CovidTracker::RegionRegistry
    self.time_period_service = CovidTracker::TimePeriodService

    PAGE_DIRECTORY = File.join("docs", "pages", "covid_tracker")

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

    # Update all pages for all time periods.
    def update_pages
      update_region_pages
      update_all_regions_pages
      puts("Daily Page Generation Complete for #{registered_regions.count} regions!") # rubocop:disable Rails/Output
    end

    def self.page_file_name(code, time_period)
      "#{code}-#{time_period_service.short_form(time_period)}"
    end

  private

    def all_regions_file_name(time_period)
      "all_regions-#{time_period_service.short_form(time_period)}"
    end

    def update_region_pages
      registered_regions.each do |region_registration|
        write_page(region_registration, THIS_WEEK)
        write_page(region_registration, THIS_MONTH)
        write_page(region_registration, SINCE_MARCH)
      end
    end

    def update_all_regions_pages
      write_all_regions_page(THIS_WEEK)
      write_all_regions_page(THIS_MONTH)
      write_all_regions_page(SINCE_MARCH)
    end

    def write_page(region_registration, time_period)
      code = region_registration.code
      page = generate_page(region_registration, time_period)
      file_name = "#{self.class.page_file_name(code, time_period)}.md"
      full_file_name = File.join(full_page_file_path(time_period), file_name)
      puts "  --  Writing page to #{full_file_name}" # rubocop:disable Rails/Output
      file = File.new(full_file_name, 'w')
      file << page
      file.close
    end

    def write_all_regions_page(time_period)
      page = generate_all_regions_page(time_period)
      full_file_name = File.join(full_page_file_path(time_period), "#{all_regions_file_name(time_period)}.md")
      file = File.new(full_file_name, 'w')
      file << page
      file.close
    end

    def full_page_file_path(time_period)
      Rails.root.join(PAGE_DIRECTORY, time_period_service.long_form(time_period))
    end

    def generate_page(region_registration, time_period)
      label = region_registration.label
      code = region_registration.code
      front_matter = generate_front_matter(label, code, time_period)
      body = generate_body(label, code, time_period)
      front_matter + body
    end

    def generate_all_regions_page(time_period)
      front_matter = generate_front_matter(ALL_REGIONS_LABEL, ALL_REGIONS_CODE, time_period)
      body = ""
      registered_regions.each do |region_registration|
        label = region_registration.label
        code = region_registration.code
        body += "\n<h3>#{label}</h3>\n"
        body += generate_body(label, code, time_period)
      end
      front_matter + body
    end

    def generate_front_matter(label, code, time_period)
      "---
title: #{label}
permalink: #{self.class.page_file_name(code, time_period)}.html
last_updated: #{time_period_service.today_str}
keywords: [\"#{label}\", \"#{time_period_service.text_form(time_period)}\"]
tags: [\"#{code}\", \"#{time_period_service.long_form(time_period)}\"]
sidebar: home_sidebar
folder: covid_tracker/#{time_period_service.long_form(time_period)}/
---
"
    end

    def generate_body(label, code, time_period)
      "
![Change in Confirmed Cases #{time_period_service.text_form(time_period)} for #{label}](images/graphs/#{code}-delta_confirmed-#{time_period_service.short_form(time_period)}_graph.png)

![Change in Confirmed Deaths #{time_period_service.text_form(time_period)} for #{label}](images/graphs/#{code}-delta_deaths-#{time_period_service.short_form(time_period)}_graph.png)
"
    end
  end
end
