# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_09_19_184739) do

  create_table "covid_tracker_region_counts", force: :cascade do |t|
    t.integer "region_id"
    t.string "date"
    t.integer "confirmed_cases"
    t.integer "delta_cases"
    t.integer "confirmed_deaths"
    t.integer "delta_deaths"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["region_id"], name: "index_covid_tracker_region_counts_on_region_id"
  end

  create_table "covid_tracker_regions", force: :cascade do |t|
    t.string "region_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["region_code"], name: "index_covid_tracker_regions_on_region_code", unique: true
  end

end
