class CreateCovidTrackerRegionCounts < ActiveRecord::Migration[5.2]
  def change
    create_table :covid_tracker_region_counts do |t|
      t.references :region
      t.string :result_code
      t.string :result_label
      t.string :date
      t.integer :cumulative_confirmed
      t.integer :delta_confirmed
      t.integer :cumulative_deaths
      t.integer :delta_deaths

      t.timestamps
    end
  end
end
