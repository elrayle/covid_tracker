# frozen_string_literal: true

require 'covid_tracker/keys'

# This class generates graphs for each stat tracked.
module CovidTracker
  module GraphGeneratorService
    IMAGE_DIRECTORY = File.join("docs", "images", "graphs")

    THIS_WEEK = CovidTracker::SiteGeneratorService::THIS_WEEK
    THIS_MONTH = CovidTracker::SiteGeneratorService::THIS_MONTH
    SINCE_MARCH = CovidTracker::SiteGeneratorService::SINCE_MARCH

    DEFAULT_MAX_VALUE = 10
    DEFAULT_CASES_BAR_COLOR = "#cc8b0e"
    DEFAULT_DEATHS_BAR_COLOR = "#cc4d0e"

    # Update all graphs for all time periods.
    # @param registered_regions [Array<CovidTracker::RegionRegistration>] registered regions
    def update_graphs(registered_regions: registry_class.registry)
      update_time_period_graphs(registered_regions: registered_regions, time_period: THIS_WEEK)
      update_time_period_graphs(registered_regions: registered_regions, time_period: THIS_MONTH)
      # update_time_period_graphs(registered_regions: registered_regions, time_period: SINCE_MARCH)
    end

  private

    # Generate all graphs for all regions for the last X days
    # @param registered_regions [Array<CovidTracker::RegionRegistration>] registered regions
    # @param time_period [Symbol] how much time should the graph cover
    # @see CovidTracker::DataService
    def update_time_period_graphs(registered_regions: registry_class.registry, time_period:)
      days = time_period_days(time_period)
      all_regions_data = data_service.all_regions_data(days: days)
      all_regions_data.each do |region_id, region_results|
        # generate_graph_for_stat(region_results: region_results, days: days, stat_key: CovidTracker::ResultKeys::CUMULATIVE_CONFIRMED)
        generate_graph_for_stat(region_results: region_results, days: days, stat_key: CovidTracker::ResultKeys::DELTA_CONFIRMED)
        # generate_graph_for_stat(region_results: region_results, days: days, stat_key: CovidTracker::ResultKeys::CUMULATIVE_DEATHS)
        generate_graph_for_stat(region_results: region_results, days: days, stat_key: CovidTracker::ResultKeys::DELTA_DEATHS)
      end
      all_regions_data.empty? ? puts("Unable to retrieve data for graphs") : puts("Graph Generation Complete for #{all_regions_data.count} regions!")
    end

    def generate_graph_for_stat(region_results:, days:, stat_key:)
      region_data = data_service.region_data(region_results: region_results)
      graph_data = extract_graph_data(region_data: region_data, days: days, stat_key: stat_key)
      characteristics = graph_characteristics(graph_data: graph_data, region_results: region_results, stat_key: stat_key, days: days)
      graph_path = stat_graph_full_path(region_id: region_id(region_data: region_data),
                                        stat_key: stat_key,
                                        days: days,
                                        last_day: last_day(region_data: region_data))
      create_gruff_graph(data: graph_data,
                         full_path: graph_path,
                         characteristics: characteristics)
    end

    # passed to create_gruff_graph
    def stat_graph_full_path(region_id:, stat_key:, days:, last_day:)
      graph_full_path(graph_filename(region_id: region_id, stat_key: stat_key, days: days, last_day: last_day))
    end

    # used to create path passed to create_gruff_graph
    def graph_full_path(graph_filename)
      path = Rails.root.join(IMAGE_DIRECTORY)
      FileUtils.mkdir_p path
      File.join(path, graph_filename)
    end

    def graph_filename(region_id:, stat_key:, days:, last_day:)
      "#{region_id}-#{stat_key}-#{days}_days_graph.png"
    end

    def graph_characteristics(graph_data:, region_results:, stat_key:, days:)
      {
        title: title(region_results: region_results, stat_key: stat_key),
        legend_key: stat_key,
        max: graph_data[2],
        bar_color: bar_color(stat_key: stat_key),
        hide_labels: hide_labels?(days: days),
        hide_legend: true
      }
    end

    def title(region_results:, stat_key:)
      region_label = data_service.region_label(region_results: region_results)
      case stat_key
        when CovidTracker::ResultKeys::CUMULATIVE_CONFIRMED
          I18n.t('covid_tracker.graphing_service.cumulative_confirmed_graph_title', region_label: region_label)
        when CovidTracker::ResultKeys::DELTA_CONFIRMED
          I18n.t('covid_tracker.graphing_service.delta_confirmed_graph_title', region_label: region_label)
        when CovidTracker::ResultKeys::CUMULATIVE_DEATHS
          I18n.t('covid_tracker.graphing_service.cumulative_deaths_graph_title', region_label: region_label)
        when CovidTracker::ResultKeys::DELTA_DEATHS
          I18n.t('covid_tracker.graphing_service.delta_deaths_graph_title', region_label: region_label)
      end
    end

    def bar_color(stat_key:)
      case stat_key
        when CovidTracker::ResultKeys::CUMULATIVE_CONFIRMED
          DEFAULT_CASES_BAR_COLOR
        when CovidTracker::ResultKeys::DELTA_CONFIRMED
          DEFAULT_CASES_BAR_COLOR
        when CovidTracker::ResultKeys::CUMULATIVE_DEATHS
          DEFAULT_DEATHS_BAR_COLOR
        when CovidTracker::ResultKeys::DELTA_DEATHS
          DEFAULT_DEATHS_BAR_COLOR
      end
    end

    def hide_labels?(days:)
      days > 10 ? true : false
    end

    def region_id(region_data:)
      data_service.region_id_from_region_data(region_data: region_data)
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

    def graph_theme(g, characteristics)
      # g.theme_pastel
      g.colors = [characteristics.fetch(:bar_color, "#cc4d0e")]
      g.marker_font_size = 20
      g.minimum_value = 0
      g.maximum_value = characteristics.fetch(:max, DEFAULT_MAX_VALUE)
      g.hide_line_markers = characteristics.fetch(:hide_line_markers, true)
      g.hide_labels = characteristics.fetch(:hide_labels, false)
      g.hide_legend = characteristics.fetch(:hide_legend, true)
      g.show_labels_for_bar_values = true
      g.label_formatting = "%d"
    end

    def create_gruff_graph(data:, full_path:, characteristics:)
      g = Gruff::Bar.new('800x400')
      graph_theme(g, characteristics)
      g.title = characteristics.fetch(:title, "")
      g.labels = data[0]
      g.data(characteristics.fetch(:legend_key, ""), data[1])
      g.write full_path
    end

    # def log_failure(authority_name, action, time_period)
    #   relative_path = performance_graph_image_path(authority_name: authority_name, action: action, time_period: time_period)
    #   exists = performance_graph_image_exists?(authority_name: authority_name, action: action, time_period: time_period)
    #   QaServer.config.monitor_logger.warn("FAILED to write performance graph at #{relative_path}") unless exists
    # end
  end
end
