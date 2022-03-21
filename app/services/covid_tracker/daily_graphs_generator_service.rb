# frozen_string_literal: true

require 'covid_tracker/keys'

# This class generates graphs for each stat tracked.
module CovidTracker
  class DailyGraphsGeneratorService
    class_attribute :data_service, :data_retrieval_service, :graph_service, :time_period_service
    self.data_service = CovidTracker::DataService
    self.data_retrieval_service = CovidTracker::DataRetrievalService
    self.graph_service = CovidTracker::GruffGraphService
    self.time_period_service = CovidTracker::TimePeriodService

    include CovidTracker::GraphDataService

    IMAGE_DIRECTORY = File.join("docs", "images", "graphs")

    THIS_WEEK = time_period_service::THIS_WEEK
    THIS_MONTH = time_period_service::THIS_MONTH

    attr_reader :registered_regions # [Array<CovidTracker::RegionRegistration>]

    # @param area [CovidTracker::CentralAreaRegistration] generate sidebar for this area
    def initialize(area:)
      @registered_regions = area.regions
    end

    # Update all graphs for all time periods.
    def update_graphs
      update_time_period_graphs(time_period: THIS_WEEK)
      update_time_period_graphs(time_period: THIS_MONTH)
    end

  private

    # Generate all graphs for all regions for the last X days
    # @param time_period [Symbol] how much time should the graph cover
    def update_time_period_graphs(time_period:)
      days = time_period_service.days(time_period)
      registered_regions.each do |region_registration|
        begin
          region_results = data_retrieval_service.region_results(region_registration: region_registration, days: days)
          generate_graph_for_stat(region_results: region_results, days: days, stat_key: CovidTracker::ResultKeys::DELTA_CONFIRMED, time_period: time_period)
          generate_graph_for_stat(region_results: region_results, days: days, stat_key: CovidTracker::ResultKeys::DELTA_DEATHS, time_period: time_period)
        rescue Exception => e
          puts "Unable to generate #{time_period_service.text_form(time_period)} graph for #{region_registration.label} -- cause: #{e.message}"
        end
      end
      registered_regions.empty? ? puts("Unable to retrieve data for daily graphs") : puts("#{days}-days Graph Generation Complete for #{registered_regions.count} regions!") # rubocop:disable Rails/Output, Metrics/LineLength
    end

    def generate_graph_for_stat(region_results:, days:, stat_key:, time_period:)
      region_data = region_results.region_data
      extracted_data = extract_daily_graph_data(region_data: region_data, days: days, stat_key: stat_key)
      graph_info = daily_graph_info(extracted_data: extracted_data, region_results: region_results, stat_key: stat_key, days: days)
      bar_info = extracted_data[:bar_info]
      filename = graph_filename(region_code: region_results.region_code, stat_key: stat_key, time_period: time_period)
      graph_path = graph_full_path(filename)
      puts "  --  Writing daily graph to #{filename}" # rubocop:disable Rails/Output
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
