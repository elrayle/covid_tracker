# frozen_string_literal: true

# This class generates graphs using the Gruff graphing gem.
module CovidTracker
  class GruffGraphService
    class << self
      # Generate all graphs for all regions for the last X days
      # @param full_path [String] full path + file name for graph write location
      # @param graph_info [String] settings that impact the entire graph (see graph_info method)
      # @param bar_info [Array<Hash>] settings that impact each bar in the graph (see bar_info method)
      def create_gruff_graph(full_path:, graph_info:, bar_info:)
        g = Gruff::Bar.new('800x400')
        graph_theme(g, graph_info, color(bar_info))
        g.title = graph_info.fetch(:title, "")
        g.labels = graph_info.fetch(:labels, {})
        bar_info.each { |bar| g.data(bar.fetch(:legend_key, ""), bar.fetch(:bar_data, [])) }
        g.write full_path
      end

      # Setup graph info specific to Gruff Graph
      # @param options [Hash] graph characteristic options (e.g. title, legend_key, etc.)
      # @option options [String] :title of graph
      # @option options [String] :max value for the y-axis
      # @option options [String] :hide_labels if true does not show labels below the graph
      # @option options [String] :hide_legend if true does not show legend for the graph
      def graph_info(options:)
        {
          title: options.fetch(:title, ""),
          title_font_size: options.fetch(:title_font_size, 25),
          labels: options.fetch(:labels, {}),
          y_max: options.fetch(:y_max, nil),
          marker_font_size: options.fetch(:marker_font_size, 15),
          hide_labels: options.fetch(:hide_labels, false),
          hide_legend: options.fetch(:hide_legend, true)
        }
      end

      # Setup data info specific to Gruff Graph for a single data set
      # @param options [Hash] graph characteristic options (e.g. title, legend_key, etc.)
      # @option options [String] :legend_key for a set of data
      # @option options [String] :bar_color for a set of data
      def bar_info(options:)
        {
          bar_data: options.fetch(:bar_data, []),
          bar_color: options.fetch(:bar_color, nil),
          legend_key: options.fetch(:legend_key, "")
        }
      end

    private

      def graph_theme(g, graph_info, colors)
        # g.theme_pastel
        g.colors = colors
        g.minimum_value = 0
        g.maximum_value = graph_info[:y_max] if graph_info.key? :y_max
        g.title_font_size = graph_info.fetch(:title_font_size, 25)
        g.marker_font_size = graph_info.fetch(:marker_font_size, 15)
        g.hide_line_markers = graph_info.fetch(:hide_line_markers, true)
        g.hide_labels = graph_info.fetch(:hide_labels, false)
        g.hide_legend = graph_info.fetch(:hide_legend, true)
        g.show_labels_for_bar_values = true
        g.label_formatting = "%d"
      end

      def color(bar_info)
        bar_info.map { |bar| bar.fetch(:bar_color, nil) }
      end

      def bar_data(data_info)
        data_info
      end
    end
  end
end
