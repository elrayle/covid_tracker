class AddCumulative7DaysToCovidTrackerRegionCounts < ActiveRecord::Migration[5.2]
  def change
    add_column :covid_tracker_region_counts, :cumulative_7_days, :integer
  end
end
