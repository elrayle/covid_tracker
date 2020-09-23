class CreateCovidTrackerRegions < ActiveRecord::Migration[5.2]
  def change
    create_table :covid_tracker_regions do |t|
      t.string :region_code

      t.timestamps
    end

    add_index :covid_tracker_regions, :region_code, unique: true
  end
end
