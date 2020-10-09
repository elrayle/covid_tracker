# frozen_string_literal: true

require 'covid_tracker/keys'

# This class generates graphs for each stat tracked.
module CovidTracker
  module WeeklyGraphsGeneratorService
    IMAGE_DIRECTORY = File.join("docs", "images", "graphs")

    SINCE_MARCH = CovidTracker::SiteGeneratorService::SINCE_MARCH

    # Update all graphs for all time periods.
    # @param registered_regions [Array<CovidTracker::RegionRegistration>] registered regions
    def update_weekly_graphs(registered_regions: registry_class.registry)
      update_7_days_graph(registered_regions: registered_regions)
    end

  private

    # Generate weekly graphs for all regions
    # @param registered_regions [Array<CovidTracker::RegionRegistration>] registered regions
    # @see CovidTracker::DataService
    def update_7_days_graph(registered_regions:)
      days = time_period_service.days(SINCE_MARCH)
      registered_regions.each do |region_registration|
        region_results = data_retrieval_service.region_results(region_registration: region_registration, days: days)
        generate_weekly_graph(region_results: region_results)
      end
      registered_regions.empty? ? puts("Unable to retrieve data for weekly graphs") : puts("Weekly Graph Generation Complete for #{registered_regions.count} regions!") # rubocop:disable Rails/Output, Metrics/LineLength
    end

    def generate_weekly_graph(region_results:)
      stat_key = CovidTracker::ResultKeys::CUMULATIVE_7_DAYS_CONFIRMED
      region_data = region_results.region_data
      extracted_data = extract_weekly_graph_data(region_data: region_data, stat_key: stat_key)
      graph_info = weekly_graph_info(extracted_data: extracted_data, region_results: region_results, stat_key: stat_key)
      bar_info = extracted_data[:bar_info]
      graph_path = weekly_graph_full_path(region_code: region_results.region_code, stat_key: stat_key)
      puts "  --  Writing weekly graph to #{graph_path}" # rubocop:disable Rails/Output
      graph_service.create_gruff_graph(full_path: graph_path,
                                       graph_info: graph_info,
                                       bar_info: [bar_info])
    end

    # passed to create_gruff_graph
    def weekly_graph_full_path(region_code:, stat_key:)
      graph_full_path(weekly_graph_filename(region_code: region_code, stat_key: stat_key))
    end

    # used to create path passed to create_gruff_graph
    def graph_full_path(graph_filename)
      Rails.root.join(IMAGE_DIRECTORY, graph_filename)
    end

    def weekly_graph_filename(region_code:, stat_key:)
      "#{region_code}-#{stat_key}_graph.png"
    end
  end
end
