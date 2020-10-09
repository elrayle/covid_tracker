# frozen_string_literal: true

module CovidTracker
  class WeeklyPagesGeneratorService
    class_attribute :registry_class, :time_period_service
    self.registry_class = CovidTracker::RegionRegistry
    self.time_period_service = CovidTracker::TimePeriodService

    TAIL_DIRECTORY = "weekly_totals"
    PAGE_DIRECTORY = File.join("docs", "pages", "covid_tracker", TAIL_DIRECTORY)
    FILE_POSTFIX = "-weekly_totals"
    KEYWORDS_TAGS = "weekly totals"

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
      puts("Page Generation Complete for #{registered_regions.count} regions!") # rubocop:disable Rails/Output
    end

    def self.page_file_name(code)
      "#{code}#{FILE_POSTFIX}"
    end

  private

    def all_regions_file_name
      self.class.page_file_name(ALL_REGIONS_CODE)
    end

    def update_region_pages
      registered_regions.each do |region_registration|
        write_page(region_registration)
      end
    end

    def update_all_regions_pages
      write_all_regions_page
    end

    def write_page(region_registration)
      code = region_registration.code
      page = generate_page(region_registration)
      file_name = "#{self.class.page_file_name(code)}.md"
      full_file_name = File.join(full_page_file_path, file_name)
      puts "  --  Writing page to #{full_file_name}" # rubocop:disable Rails/Output
      file = File.new(full_file_name, 'w')
      file << page
      file.close
    end

    def write_all_regions_page
      page = generate_all_regions_page
      full_file_name = File.join(full_page_file_path, "#{all_regions_file_name}.md")
      file = File.new(full_file_name, 'w')
      file << page
      file.close
    end

    def full_page_file_path
      Rails.root.join(PAGE_DIRECTORY)
    end

    def generate_page(region_registration)
      label = region_registration.label
      code = region_registration.code
      front_matter = generate_front_matter(label, code)
      body = generate_body(label, code)
      front_matter + body
    end

    def generate_all_regions_page
      front_matter = generate_front_matter(ALL_REGIONS_LABEL, ALL_REGIONS_CODE)
      body = ""
      registered_regions.each do |region_registration|
        label = region_registration.label
        code = region_registration.code
        body += "\n<h3>#{label}</h3>\n"
        body += generate_body(label, code)
      end
      front_matter + body
    end

    def generate_front_matter(label, code)
      "---
title: #{label}
permalink: #{self.class.page_file_name(code)}.html
last_updated: #{time_period_service.today_str}
keywords: [\"#{label}\", \"#{KEYWORDS_TAGS}\"]
tags: [\"#{code}\", \"#{KEYWORDS_TAGS}\"]
sidebar: home_sidebar
folder: covid_tracker/#{TAIL_DIRECTORY}/
---
"
    end

    def generate_body(label, code)
      "
![Weekly Totals of Confirmed Cases for #{label}](images/graphs/#{code}#{FILE_POSTFIX}_graph.png)
"
    end
  end
end
