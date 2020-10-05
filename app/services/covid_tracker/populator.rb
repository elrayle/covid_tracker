module CovidTracker
  class Populator
    class_attribute :registry_class, :data_service, :time_period_service
    self.registry_class = CovidTracker::RegionRegistry
    self.data_retrieval_service = CovidTracker::DataRetrievalService
    self.time_period_service = CovidTracker::TimePeriodService

    def populate_today
      populate_range(oldest_date: today_date, newest_date: today_date)
    end

    def populate_since(date:)
      populate_range(oldest_date: date, newest_date: today_date)
    end

    # @param oldest_date |String| oldest date in the range (e.g. "2020-03-01")
    # @param newest_date |String| most recent date in the range (e.g. "2020-03-31")
    def populate_range(oldest_date:, newest_date:)
      days = days_in_range(oldest_date: oldest_date, newest_date: newest_date)
      dt = newest_date
      0.step(days, 7) do |idx|
        days_dec = (idx + 7) < days ? 7 : days - idx
        data = data_retrieval_service.all_regions_data_in_range(date: dt, days: days_dec, use_cache: false)
        populate(data)
        dt = str_date_from_idx(dt, days_dec)
      end
    end

  private

    def today_date

    end

    def populate(data)
      
    end
  end
end
