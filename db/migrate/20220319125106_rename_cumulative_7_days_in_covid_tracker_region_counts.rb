class RenameCumulative7DaysInCovidTrackerRegionCounts < ActiveRecord::Migration[5.2]
  def change
    rename_column :covid_tracker_region_counts, :cumulative_7_days, :cumulative_7_days_confirmed
  end
end
