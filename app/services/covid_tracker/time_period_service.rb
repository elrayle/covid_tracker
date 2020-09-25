# frozen_string_literal: true

module CovidTracker
  class TimePeriodService
    class_attribute :data_service
    self.data_service = CovidTracker::DataService

    THIS_WEEK = :this_week
    THIS_MONTH = :this_month
    SINCE_MARCH = :since_march

    # @param time_period [Symbol] one of THIS_WEEK, THIS_MONTH, or SINCE_MARCH
    # @return [String] the text string identifying the time period (e.g. "This Week")
    def self.text_form(time_period)
      case time_period
      when THIS_WEEK
        "This Week"
      when THIS_MONTH
        "This Month"
      when SINCE_MARCH
        "Since March"
      end
    end

    # @param time_period [Symbol] one of THIS_WEEK, THIS_MONTH, or SINCE_MARCH
    # @return [String] the long form of the time period used for file names and ids (e.g. "this_week")
    def self.long_form(time_period)
      case time_period
      when THIS_WEEK
        "this_week"
      when THIS_MONTH
        "this_month"
      when SINCE_MARCH
        "since_march"
      end
    end

    # @param time_period [Symbol] one of THIS_WEEK, THIS_MONTH, or SINCE_MARCH
    # @return [String] the short form of the time period used for file names and ids (e.g. "7_days")
    def self.short_form(time_period)
      case time_period
      when THIS_WEEK
        "7_days"
      when THIS_MONTH
        "30_days"
      when SINCE_MARCH
        "since_march"
      end
    end

    # @param time_period [Symbol] one of THIS_WEEK, THIS_MONTH, or SINCE_MARCH
    # @return [Integer] the count of days in the time period (e.g. 7)
    def self.days(time_period)
      case time_period
      when THIS_WEEK
        7
      when THIS_MONTH
        30
      when SINCE_MARCH
        latest_dt = DateTime.now.in_time_zone("Eastern Time (US & Canada)") - 1.day
        march01 = DateTime.strptime("03-01-2020 22:00:00 Eastern Time (US & Canada)", '%m-%d-%Y %H:%M:%S %Z')
        (latest_dt.to_date - march01.to_date).to_i
      end
    end

    # @return [String] today's date as a string (used by Jekyll for page dates) (e.g. "Sep 15, 2020")
    def self.today_str
      dt = DateTime.now.in_time_zone(data_service.data_time_zone)
      dt.strftime("%b %-d, %Y")
    end

    # @param date_str [String] string date to convert (e.g. "2020-03-22")
    # @return [String] the shortened label version of the date (e.g. "Mar-22")
    def self.date_to_label(date_str)
      str_to_date(date_str).strftime("%b-%e").gsub(/\s+/, "")
    end

    # @param date_str [String] starting date (e.g. "2020-03-22")
    # @param idx [Integer] number of days earlier for the return date (e.g. 2)
    # @return [String] date string that is idx days earlier (e.g. "2020-03-20")
    def self.str_date_from_idx(date_str, idx)
      date_to_str(str_to_date(date_str) - idx.days)
    end

    # @param date_str [String] string date to convert (e.g. "2020-03-22")
    # @return [Date] instance of Date created from the string date
    def self.str_to_date(date_str)
      Date.strptime(date_str, "%F")
    end

    # @param date [Date] the date to convert (e.g. Sun, 22 Mar 2020)
    # @return [String] converted string date (e.g. "2020-03-22")
    def self.date_to_str(date)
      date.strftime("%F")
    end

    # @param oldest_date [Date] oldest date in the range (e.g. "2020-03-22")
    # @param newest_date [Date] newest date in the range (e.g. "2020-03-25")
    # @return [Integer] number of days in the range inclusive (e.g. 4)
    def self.days_in_range(oldest_date:, newest_date:)
      oldest_dt = str_to_date(oldest_date)
      newest_dt = str_to_date(newest_date)
      (newest_dt - oldest_dt).to_i + 1
    end
  end
end
