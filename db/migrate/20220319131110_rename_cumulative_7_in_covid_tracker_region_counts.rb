class RenameCumulative7InCovidTrackerRegionCounts < ActiveRecord::Migration[5.2]
  def change
    rename_column :covid_tracker_region_counts, :cumulative_7_days_confirmed, :rolling_7_days_confirmed
    rename_column :covid_tracker_region_counts, :cumulative_7_days_deaths, :rolling_7_days_deaths
  end
end
