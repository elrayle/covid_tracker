module CovidTracker
  class RegionCount < ApplicationRecord
    self.table_name = 'covid_tracker_region_counts'

    class_attribute :data_service, :time_period_service
    self.data_service = CovidTracker::DataService
    self.time_period_service = CovidTracker::TimePeriodService

    belongs_to :region, class_name: "CovidTracker::Region", foreign_key: "region_id"

    class << self
      # @param region_code [String] the region code for which the data is being recorded  (e.g. 'usa-alabama-wilcox')
      # @param region_datum [CovidTracker::RegionDatum] data to be recorded
      # @returns [CovidTracker::RegionCount] saved instance of this class populated with the data
      def for(region_code:, region_datum:)
        region_count = new
        region_count.region_id = CovidTracker::Region.find_or_create_region_for(region_code: region_code).id
        region_count.result_code = data_service.result_code(region_datum)
        region_count.result_label = data_service.result_label(region_datum)
        region_count.date = data_service.date(region_datum)
        region_count.cumulative_confirmed = data_service.cumulative_confirmed(region_datum)
        region_count.delta_confirmed = data_service.delta_confirmed(region_datum)
        region_count.cumulative_deaths = data_service.cumulative_deaths(region_datum)
        region_count.delta_deaths = data_service.delta_deaths(region_datum)
        region_count.rolling_7_days_confirmed = calculate_rolling_7_days_confirmed(region_count.delta_confirmed, region_code, region_count.date)
        region_count.rolling_7_days_deaths = calculate_rolling_7_days_deaths(region_count.delta_deaths, region_code, region_count.date)
        region_count.save
        region_count
      end

      # @param region_code [String] the region code for which the data is being retrieved  (e.g. 'usa-alabama-wilcox')
      # @param date [String] date for which to retrieve the data
      # @param update [Boolean] if true, update 7 day cumulative count; otherwise, skip update if false
      # @returns [Array<CovidTracker::RegionCount>] instance of this class populated with the retrieved data
      def find_by(region_code:, date: nil, update: true)
        region_id = CovidTracker::Region.find_or_create_region_for(region_code: region_code).id
        where_clause = { region_id: region_id }
        where_clause[:date] = date unless date.blank?
        count_data = where(where_clause)
        count_data = update_each_rolling_7_days_confirmed(count_data, region_code) if update
        count_data = update_each_rolling_7_days_deaths(count_data, region_code) if update
        count_data
      end

    private

      # @param delta_confirmed [Integer] number of confirmed cases for date being calculated
      # @param region_code [String] the region code for which the data is being retrieved  (e.g. 'usa-alabama-wilcox')
      # @param date [String] date for which to retrieve the data
      def calculate_rolling_7_days_confirmed(delta_confirmed, region_code, date)
        rolling_7_days_confirmed = delta_confirmed
        1.upto(6) do |idx|
          dt = time_period_service.date_to_str(time_period_service.str_to_date(date) - idx.days)
          prev_day = find_by(region_code: region_code, date: dt, update: false)&.first
          rolling_7_days_confirmed += prev_day.delta_confirmed if prev_day
          return -1 unless prev_day # set to -1 if any of the days during the last 7 days do not have values
        end
        rolling_7_days_confirmed
      end

      # @param delta_deaths [Integer] number of deaths for date being calculated
      # @param region_code [String] the region code for which the data is being retrieved  (e.g. 'usa-alabama-wilcox')
      # @param date [String] date for which to retrieve the data
      def calculate_rolling_7_days_deaths(delta_deaths, region_code, date)
        rolling_7_days_deaths = delta_deaths
        1.upto(6) do |idx|
          dt = time_period_service.date_to_str(time_period_service.str_to_date(date) - idx.days)
          prev_day = find_by(region_code: region_code, date: dt, update: false)&.first
          rolling_7_days_deaths += prev_day.delta_deaths if prev_day
          return -1 unless prev_day # set to -1 if any of the days during the last 7 days do not have values
        end
        rolling_7_days_deaths
      end

      # @param count_data [Array<CovidTracker::RegionCounts>] the instances getting rolling_7_days updated
      # @param region_code [String] the region code for which the data is being retrieved  (e.g. 'usa-alabama-wilcox')
      def update_each_rolling_7_days_confirmed(count_data, region_code)
        count_data.map { |count_datum| update_rolling_7_days_confirmed(count_datum, region_code) }
      end

      # @param count_data [Array<CovidTracker::RegionCounts>] the instances getting rolling_7_days_deaths updated
      # @param region_code [String] the region code for which the data is being retrieved  (e.g. 'usa-alabama-wilcox')
      def update_each_rolling_7_days_deaths(count_data, region_code)
        count_data.map { |count_datum| update_rolling_7_days_deaths(count_datum, region_code) }
      end

      # @param count_datum [CovidTracker::RegionCounts] the instance getting rolling_7_days_confirmed updated
      # @param region_code [String] the region code for which the data is being retrieved  (e.g. 'usa-alabama-wilcox')
      def update_rolling_7_days_confirmed(count_datum, region_code)
        return count_datum if count_datum.rolling_7_days_confirmed&.positive? || count_datum.rolling_7_days_confirmed&.zero?
        count_datum.rolling_7_days_confirmed = calculate_rolling_7_days_confirmed(count_datum.delta_confirmed, region_code, count_datum.date)
        count_datum.save
        count_datum
      end

      # @param count_datum [CovidTracker::RegionCounts] the instance getting rolling_7_days_deaths updated
      # @param region_code [String] the region code for which the data is being retrieved  (e.g. 'usa-alabama-wilcox')
      def update_rolling_7_days_deaths(count_datum, region_code)
        return count_datum if count_datum.rolling_7_days_deaths&.positive? || count_datum.rolling_7_days_deaths&.zero?
        count_datum.rolling_7_days_deaths = calculate_rolling_7_days_deaths(count_datum.delta_deaths, region_code, count_datum.date)
        count_datum.save
        count_datum
      end
    end
  end
end
