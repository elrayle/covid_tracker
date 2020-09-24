# frozen_string_literal: true

require 'covid_tracker/keys'

# This class generates graphs for each stat tracked.
module CovidTracker
  module GraphDataService
    DEFAULT_MAX_VALUE = 10
    DEFAULT_CASES_BAR_COLOR = "#cc8b0e"
    DEFAULT_DEATHS_BAR_COLOR = "#cc4d0e"

  private

    def graph_info(extracted_data:, region_results:, stat_key:, days:)
      options = {
        title: title(region_results: region_results, stat_key: stat_key),
        labels: extracted_data[:labels],
        y_max: extracted_data[:max_value],
        marker_font_size: marker_font_size(days: days),
        hide_labels: false,
        hide_legend: true
      }
      graph_service.graph_info(options: options)
    end

    def bar_info(values, stat_key, max_value)
      options = {
        bar_data: values,
        bar_color: bar_color(stat_key: stat_key),
        legend_key: stat_key,
        max_value: max_value
      }
      graph_service.bar_info(options: options)
    end

    def extract_graph_data(region_data:, days:, stat_key:) # rubocop:disable Metrics/MethodLength
      labels = {}
      bar_data = []
      max_value = 0
      region_data.each_with_index do |datum, idx|
        result = datum[CovidTracker::ResultKeys::RESULT_SECTION]
        labels[idx] = graph_label(result, days, idx)
        bar_data << result[stat_key]
        max_value = result[stat_key] if result[stat_key] > max_value
        break if idx > days
      end
      max_value = max_value > DEFAULT_MAX_VALUE ? max_value : DEFAULT_MAX_VALUE
      {
        labels: labels,
        max_value: max_value,
        bar_info: bar_info(bar_data, stat_key, max_value)
      }
    end

    def title(region_results:, stat_key:)
      region_label = data_retrieval_service.region_label(region_results: region_results)
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

    def marker_font_size(days:)
      days > 10 ? 15 : 20
    end

    def graph_label(result, days, idx)
      return " " if days > 10 && idx.positive? && idx < days - 1
      time_period_service.date_to_label(result[CovidTracker::ResultKeys::DATE])
    end
  end
end
