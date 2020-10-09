# frozen_string_literal: true

require 'covid_tracker/keys'

# This class generates graphs for each stat tracked.
module CovidTracker
  module DailyGraphsGeneratorService
    IMAGE_DIRECTORY = File.join("docs", "images", "graphs")

    THIS_WEEK = CovidTracker::SiteGeneratorService::THIS_WEEK
    THIS_MONTH = CovidTracker::SiteGeneratorService::THIS_MONTH
    SINCE_MARCH = CovidTracker::SiteGeneratorService::SINCE_MARCH

    # Update all graphs for all time periods.
    # @param registered_regions [Array<CovidTracker::RegionRegistration>] registered regions
    def update_daily_graphs(registered_regions: registry_class.registry)
      update_time_period_graphs(registered_regions: registered_regions, time_period: THIS_WEEK)
      update_time_period_graphs(registered_regions: registered_regions, time_period: THIS_MONTH)
      update_time_period_graphs(registered_regions: registered_regions, time_period: SINCE_MARCH)
    end

  private

    # Generate all graphs for all regions for the last X days
    # @param registered_regions [Array<CovidTracker::RegionRegistration>] registered regions
    # @param time_period [Symbol] how much time should the graph cover
    # @see CovidTracker::DataService
    def update_time_period_graphs(registered_regions:, time_period:)
      days = time_period_service.days(time_period)
      registered_regions.each do |region_registration|
        region_results = data_retrieval_service.region_results(region_registration: region_registration, days: days)

        # generate_graph_for_stat(region_results: region_results, days: days, stat_key: CovidTracker::ResultKeys::CUMULATIVE_CONFIRMED, time_period: time_period)
        generate_graph_for_stat(region_results: region_results, days: days, stat_key: CovidTracker::ResultKeys::DELTA_CONFIRMED, time_period: time_period)
        # generate_graph_for_stat(region_results: region_results, days: days, stat_key: CovidTracker::ResultKeys::CUMULATIVE_DEATHS, time_period: time_period)
        generate_graph_for_stat(region_results: region_results, days: days, stat_key: CovidTracker::ResultKeys::DELTA_DEATHS, time_period: time_period)
      end
      registered_regions.empty? ? puts("Unable to retrieve data for daily graphs") : puts("#{days}-days Graph Generation Complete for #{registered_regions.count} regions!") # rubocop:disable Rails/Output, Metrics/LineLength
    end

    def generate_graph_for_stat(region_results:, days:, stat_key:, time_period:)
      region_data = region_results.region_data
      extracted_data = extract_daily_graph_data(region_data: region_data, days: days, stat_key: stat_key)
      graph_info = daily_graph_info(extracted_data: extracted_data, region_results: region_results, stat_key: stat_key, days: days)
      bar_info = extracted_data[:bar_info]
      graph_path = stat_graph_full_path(region_code: region_results.region_code,
                                        stat_key: stat_key,
                                        time_period: time_period)
      puts "  --  Writing daily graph to #{graph_path}" # rubocop:disable Rails/Output
      graph_service.create_gruff_graph(full_path: graph_path,
                                       graph_info: graph_info,
                                       bar_info: [bar_info])
    end

    # passed to create_gruff_graph
    def stat_graph_full_path(region_code:, stat_key:, time_period:)
      graph_full_path(graph_filename(region_code: region_code, stat_key: stat_key, time_period: time_period))
    end

    # used to create path passed to create_gruff_graph
    def graph_full_path(graph_filename)
      Rails.root.join(IMAGE_DIRECTORY, graph_filename)
    end

    def graph_filename(region_code:, stat_key:, time_period:)
      "#{region_code}-#{stat_key}-#{time_period_service.short_form(time_period)}_graph.png"
    end
  end
end
