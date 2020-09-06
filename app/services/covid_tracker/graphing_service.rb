# frozen_string_literal: true

require 'covid_tracker/keys'

# This class generates graphs for each stat tracked.
module CovidTracker
  class GraphingService
    class << self
      # include QaServer::PerformanceHistoryDataKeys
      include CovidTracker::GruffGraph

      class_attribute :data_service_class
      self.data_service_class = CovidTracker::DataService

      DEFAULT_MAX_VALUE = 10

      # @param region_id [String] identifier of the region to graph (e.g. ":USA:New_York:Cortland")
      # @param stat_key [Symbol] key for statistic represented in the graph
      # @param days [Integer] number of days to graph
      # @param last_day [String] most recent day represented in the graph
      # @return [String] Path to use with <image> tags
      def stat_graph_image_path(region_id:, stat_key:, days:, last_day:)
        File.join(graph_image_path, graph_filename(region_id: region_id, stat_key: stat_key, days: days, last_day: last_day))
      end

      # Used by presenter to add indicator in graph info of whether or not the graph exists # TODO: Is this needed?
      # @param region_id [String] identifier of the region to graph (e.g. ":USA:New_York:Cortland")
      # @param stat_key [Symbol] key for statistic represented in the graph
      # @param days [Integer] number of days to graph
      # @param last_day [String] most recent day represented in the graph
      # @return [Boolean] true if image for graph exists; otherwise, false
      def stat_graph_image_exists?(region_id:, stat_key:, days:, last_day:)
        File.exist?(stat_graph_full_path(region_id: region_id, stat_key: stat_key, days: days, last_day: last_day))
      end

      # Generate all graphs for all regions for the last X days
      # @param days [Integer] number of days to graph
      # @see CovidTracker::DataService
      def update_all_graphs(days:)
        all_regions_data = data_service_class.all_regions_data(days: days)
        all_regions_data.each do |region_id, region_results|
          region_data = data_service_class.region_data(region_results: region_results)
          # generate_graph_for_stat(region_data: region_data, days: days, stat_key: CovidTracker::ResultKeys::CUMULATIVE_CONFIRMED)
          generate_graph_for_stat(region_data: region_data, days: days, stat_key: CovidTracker::ResultKeys::DELTA_CONFIRMED)
          # generate_graph_for_stat(region_data: region_data, days: days, stat_key: CovidTracker::ResultKeys::CUMULATIVE_DEATHS)
          generate_graph_for_stat(region_data: region_data, days: days, stat_key: CovidTracker::ResultKeys::DELTA_DEATHS)
        end
        all_regions_data.empty? ? puts("Unable to retrieve data for graphs") : puts("Graph Generation Complete!")
      end

      private

        def generate_graph_for_stat(region_data:, days:, stat_key:)
          graph_data = extract_graph_data(region_data: region_data, days: days, stat_key: stat_key)
          create_gruff_graph(graph_data: graph_data,
                             stat_key: stat_key,
                             # title: region_title(CovidTracker::DataService.region_label),
                             graph_full_path: stat_graph_full_path(region_id: region_id(region_data: region_data),
                                                                   stat_key: stat_key,
                                                                   days: days,
                                                                   last_day: last_day(region_data: region_data)))
        end

        def stat_graph_full_path(region_id:, stat_key:, days:, last_day:)
          graph_full_path(graph_filename(region_id: region_id, stat_key: stat_key, days: days, last_day: last_day))
        end

        def graph_filename(region_id:, stat_key:, days:, last_day:)
          "#{last_day}_#{region_id}_#{stat_key}_#{days}_days_graph.png"
        end

        def region_id(region_data:)
          data_service_class.region_id_from_region_data(region_data: region_data)
        end

        def last_day(region_data:)
          region_data.last[CovidTracker::ResultKeys::RESULT_SECTION][CovidTracker::ResultKeys::DATE]
        end

        def date_to_label(date)
          Date.strptime(date, "%F").strftime("%b-%e").gsub(/\s+/, "")
        end

        def extract_graph_data(region_data:, days:, stat_key:)
          labels = {}
          values = []
          max_value = 0
          region_data.each_with_index do |datum, idx|
            result = datum[CovidTracker::ResultKeys::RESULT_SECTION]
            labels[idx] = date_to_label(result[CovidTracker::ResultKeys::DATE])
            values << result[stat_key]
            max_value = result[stat_key] if result[stat_key] > max_value
            break if idx > days
          end
          max_value = max_value > DEFAULT_MAX_VALUE ? max_value : DEFAULT_MAX_VALUE
          [labels, values, max_value]
        end

        def graph_theme(g, x_axis_label, max)
          # g.theme_pastel
          g.colors = ["#cc4d0e"]
          g.marker_font_size = 20
          # g.x_axis_increment = 10
          # g.x_axis_label = x_axis_label
          # g.y_axis_label = ""
          g.minimum_value = 0
          g.maximum_value = max
          g.hide_line_markers = true
          g.show_labels_for_bar_values = true
          g.label_formatting = "%d"
          # g.graph_height = 20
        end

        def create_gruff_graph(graph_data:, graph_full_path:, stat_key:, x_axis_label: "", title: "")
          g = Gruff::Bar.new('800x400')
          graph_theme(g, x_axis_label, graph_data[2])
          g.title = title
          g.labels = graph_data[0]
          g.data(stat_key, graph_data[1]) # first parameter is legend label and is empty string because legend isn't being displayed
          g.write graph_full_path
        end

        # def log_failure(authority_name, action, time_period)
        #   relative_path = performance_graph_image_path(authority_name: authority_name, action: action, time_period: time_period)
        #   exists = performance_graph_image_exists?(authority_name: authority_name, action: action, time_period: time_period)
        #   QaServer.config.monitor_logger.warn("FAILED to write performance graph at #{relative_path}") unless exists
        # end
    end
  end
end
