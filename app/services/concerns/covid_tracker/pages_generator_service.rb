# frozen_string_literal: true

module CovidTracker
  module PagesGeneratorService
    PAGE_DIRECTORY = File.join("docs", "pages", "covid_tracker")

    THIS_WEEK = CovidTracker::SiteGeneratorService::THIS_WEEK
    THIS_MONTH = CovidTracker::SiteGeneratorService::THIS_MONTH
    SINCE_MARCH = CovidTracker::SiteGeneratorService::SINCE_MARCH

    ALL_REGIONS_LABEL = CovidTracker::SiteGeneratorService::ALL_REGIONS_LABEL
    ALL_REGIONS_ID = CovidTracker::SiteGeneratorService::ALL_REGIONS_ID

    # Update all pages for all time periods.
    # @param registered_regions [Array<CovidTracker::RegionRegistration>] registered regions
    def update_pages(registered_regions: registry_class.registry)
      update_region_pages(registered_regions)
      update_all_regions_pages(registered_regions)
      puts("Page Generation Complete for #{registered_regions.count} regions!") # rubocop:disable Rails/Output
    end

  private

    def page_file_name(id, time_period)
      "#{id}-#{time_period_service.short_form(time_period)}"
    end

    def all_regions_file_name(time_period)
      "all_regions-#{time_period_service.short_form(time_period)}"
    end

    def update_region_pages(registered_regions)
      registered_regions.each do |region_registration|
        write_page(region_registration, THIS_WEEK)
        write_page(region_registration, THIS_MONTH)
        write_page(region_registration, SINCE_MARCH)
      end
    end

    def update_all_regions_pages(registered_regions)
      write_all_regions_page(registered_regions, THIS_WEEK)
      write_all_regions_page(registered_regions, THIS_MONTH)
      write_all_regions_page(registered_regions, SINCE_MARCH)
    end

    def write_page(region_registration, time_period)
      id = region_registration.id
      page = generate_page(region_registration, time_period)
      page_file_name = "#{page_file_name(id, time_period)}.md"
      full_file_name = File.join(full_page_file_path(time_period), page_file_name)
      puts "  --  Writing page to #{page_file_name}" # rubocop:disable Rails/Output
      file = File.new(full_file_name, 'w')
      file << page
      file.close
    end

    def write_all_regions_page(registered_regions, time_period)
      page = generate_all_regions_page(registered_regions, time_period)
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
      id = region_registration.id
      front_matter = generate_front_matter(label, id, time_period)
      body = generate_body(label, id, time_period)
      front_matter + body
    end

    def generate_all_regions_page(registered_regions, time_period)
      front_matter = generate_front_matter(ALL_REGIONS_LABEL, ALL_REGIONS_ID, time_period)
      body = ""
      registered_regions.each do |region_registration|
        label = region_registration.label
        id = region_registration.id
        body += "\n<h3>#{label}</h3>\n"
        body += generate_body(label, id, time_period)
      end
      front_matter + body
    end

    def generate_front_matter(label, id, time_period)
      "---
title: #{label}
permalink: #{page_file_name(id, time_period)}.html
last_updated: #{time_period_service.today_str}
keywords: [\"#{label}\", \"#{time_period_service.text_form(time_period)}\"]
tags: [\"#{id}\", \"#{time_period_service.long_form(time_period)}\"]
sidebar: home_sidebar
folder: covid_tracker/#{time_period_service.long_form(time_period)}/
---
"
    end

    def generate_body(label, id, time_period)
      "
![Change in Confirmed Cases #{time_period_service.text_form(time_period)} for #{label}](images/graphs/#{id}-delta_confirmed-#{time_period_service.short_form(time_period)}_graph.png)

![Change in Confirmed Deaths #{time_period_service.text_form(time_period)} for #{label}](images/graphs/#{id}-delta_deaths-#{time_period_service.short_form(time_period)}_graph.png)
"
    end
  end
end
