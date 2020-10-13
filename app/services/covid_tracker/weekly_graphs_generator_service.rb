# frozen_string_literal: true

require 'covid_tracker/keys'

# This class generates graphs for each stat tracked.
module CovidTracker
  class WeeklyGraphsGeneratorService
    class_attribute :data_service, :data_retrieval_service, :graph_service, :time_period_service
    self.data_service = CovidTracker::DataService
    self.data_retrieval_service = CovidTracker::DataRetrievalService
    self.graph_service = CovidTracker::GruffGraphService
    self.time_period_service = CovidTracker::TimePeriodService

    include CovidTracker::GraphDataService

    IMAGE_DIRECTORY = File.join("docs", "images", "graphs")
    FILE_POSTFIX = "-weekly_totals"

    SINCE_MARCH = time_period_service::SINCE_MARCH

    attr_reader :registered_regions # [Array<CovidTracker::RegionRegistration>]

    # @param area [CovidTracker::CentralAreaRegistration] generate sidebar for this area
    def initialize(area:)
      @registered_regions = area.regions
    end

    # Generate weekly graphs for all regions
    def update_graphs
      days = time_period_service.days(SINCE_MARCH)
      registered_regions.each do |region_registration|
        region_results = data_retrieval_service.region_results(region_registration: region_registration, days: days)
        generate_weekly_graph(region_results: region_results)
      end
      registered_regions.empty? ? puts("Unable to retrieve data for weekly graphs") : puts("Weekly Graph Generation Complete for #{registered_regions.count} regions!") # rubocop:disable Rails/Output, Metrics/LineLength
    end

  private

    def generate_weekly_graph(region_results:)
      stat_key = CovidTracker::ResultKeys::CUMULATIVE_7_DAYS_CONFIRMED
      region_data = region_results.region_data
      extracted_data = extract_weekly_graph_data(region_data: region_data, stat_key: stat_key)
      graph_info = weekly_graph_info(extracted_data: extracted_data, region_results: region_results, stat_key: stat_key)
      bar_info = extracted_data[:bar_info]
      graph_path = weekly_graph_full_path(region_code: region_results.region_code)
      puts "  --  Writing weekly graph to #{graph_path}" # rubocop:disable Rails/Output
      graph_service.create_gruff_graph(full_path: graph_path,
                                       graph_info: graph_info,
                                       bar_info: [bar_info])
    end

    # passed to create_gruff_graph
    def weekly_graph_full_path(region_code:)
      graph_full_path(weekly_graph_filename(region_code: region_code))
    end

    # used to create path passed to create_gruff_graph
    def graph_full_path(graph_filename)
      Rails.root.join(IMAGE_DIRECTORY, graph_filename)
    end

    def weekly_graph_filename(region_code:)
      "#{region_code}#{FILE_POSTFIX}_graph.png"
    end
  end
end
