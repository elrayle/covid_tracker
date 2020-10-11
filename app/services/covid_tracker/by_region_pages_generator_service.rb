# frozen_string_literal: true

module CovidTracker
  class ByRegionPagesGeneratorService
    class_attribute :registry_class, :time_period_service
    self.registry_class = CovidTracker::RegionRegistry
    self.time_period_service = CovidTracker::TimePeriodService

    TAIL_DIRECTORY = "by_region"
    PAGE_DIRECTORY = File.join("docs", "pages", "covid_tracker", TAIL_DIRECTORY)
    FILE_POSTFIX = "-by_region"
    KEYWORDS_TAGS = "by region"

    THIS_WEEK = time_period_service::THIS_WEEK
    THIS_MONTH = time_period_service::THIS_MONTH
    SINCE_MARCH = time_period_service::SINCE_MARCH

    attr_reader :registered_regions

    # @param registered_regions [Array<CovidTracker::RegionRegistration>] registered regions
    def initialize(registered_regions: registry_class.registry)
      @registered_regions = registered_regions
    end

    # Update all pages for all regions.
    def update_pages
      update_region_pages
      puts("By Region Page Generation Complete for #{registered_regions.count} regions!") # rubocop:disable Rails/Output
    end

    def self.page_file_name(code)
      "#{code}#{FILE_POSTFIX}"
    end

  private

    def update_region_pages
      registered_regions.each do |region_registration|
        write_page(region_registration)
      end
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
<h3>Weekly Totals Since March</h3>

![Weekly Totals of Confirmed Cases for #{label}](images/graphs/#{code}#{CovidTracker::WeeklyPagesGeneratorService::FILE_POSTFIX}_graph.png)

<h3>Last 30 Days</h3>

![Change in Confirmed Cases #{time_period_service.text_form(THIS_MONTH)} for #{label}](images/graphs/#{code}-delta_confirmed-#{time_period_service.short_form(THIS_MONTH)}_graph.png)

![Change in Confirmed Deaths #{time_period_service.text_form(THIS_MONTH)} for #{label}](images/graphs/#{code}-delta_deaths-#{time_period_service.short_form(THIS_MONTH)}_graph.png)

<h3>Last 7 Days</h3>

![Change in Confirmed Cases #{time_period_service.text_form(THIS_WEEK)} for #{label}](images/graphs/#{code}-delta_confirmed-#{time_period_service.short_form(THIS_WEEK)}_graph.png)

![Change in Confirmed Deaths #{time_period_service.text_form(THIS_WEEK)} for #{label}](images/graphs/#{code}-delta_deaths-#{time_period_service.short_form(THIS_WEEK)}_graph.png)

<h3>Since March</h3>

![Change in Confirmed Cases #{time_period_service.text_form(SINCE_MARCH)} for #{label}](images/graphs/#{code}-delta_confirmed-#{time_period_service.short_form(SINCE_MARCH)}_graph.png)

![Change in Confirmed Deaths #{time_period_service.text_form(SINCE_MARCH)} for #{label}](images/graphs/#{code}-delta_deaths-#{time_period_service.short_form(SINCE_MARCH)}_graph.png)
"
    end
  end
end
