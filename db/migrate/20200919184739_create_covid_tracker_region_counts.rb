class CreateCovidTrackerRegionCounts < ActiveRecord::Migration[5.2]
  def change
    create_table :covid_tracker_region_counts do |t|
      t.references :region
      t.string :date
      t.integer :confirmed_cases
      t.integer :delta_cases
      t.integer :confirmed_deaths
      t.integer :delta_deaths

      t.timestamps
    end

    # add_index :covid_tracker_region_counts, :region_id
  end
end
