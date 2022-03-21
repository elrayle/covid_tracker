class AddCumulative7DaysDeathsToCovidTrackerRegionCounts < ActiveRecord::Migration[5.2]
  def change
    add_column :covid_tracker_region_counts, :cumulative_7_days_deaths, :integer
  end
end
