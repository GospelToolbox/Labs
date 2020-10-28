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

ActiveRecord::Schema.define(version: 20200331013725) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "apps_team_schedule_schedules", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.string "schedule"
    t.datetime "last_updated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_apps_team_schedule_schedules_on_organization_id"
  end

  create_table "pco_arrangements", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.bigint "pco_song_id"
    t.string "pco_id"
    t.string "name"
    t.float "bpm"
    t.string "meter"
    t.text "notes"
    t.integer "length"
    t.text "sequence"
    t.text "sequence_short"
    t.boolean "has_chords"
    t.boolean "has_chord_chart"
    t.text "chord_chart"
    t.string "chord_chart_key"
    t.text "lyrics"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_pco_arrangements_on_organization_id"
    t.index ["pco_song_id"], name: "index_pco_arrangements_on_pco_song_id"
  end

  create_table "pco_keys", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.bigint "pco_arrangement_id"
    t.string "pco_id"
    t.string "name"
    t.text "alternate_keys"
    t.string "starting_key"
    t.string "ending_key"
    t.boolean "starting_minor"
    t.boolean "ending_minor"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_pco_keys_on_organization_id"
    t.index ["pco_arrangement_id"], name: "index_pco_keys_on_pco_arrangement_id"
  end

  create_table "pco_plan_items", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.bigint "pco_plan_id"
    t.bigint "pco_song_id"
    t.bigint "pco_arrangement_id"
    t.bigint "pco_key_id"
    t.string "pco_id"
    t.string "name"
    t.text "description"
    t.string "item_type"
    t.integer "length"
    t.text "service_position"
    t.integer "service_sequence"
    t.text "custom_arrangement_sequence"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_pco_plan_items_on_organization_id"
    t.index ["pco_arrangement_id"], name: "index_pco_plan_items_on_pco_arrangement_id"
    t.index ["pco_key_id"], name: "index_pco_plan_items_on_pco_key_id"
    t.index ["pco_plan_id"], name: "index_pco_plan_items_on_pco_plan_id"
    t.index ["pco_song_id"], name: "index_pco_plan_items_on_pco_song_id"
  end

  create_table "pco_plans", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.bigint "pco_service_type_id"
    t.string "pco_id"
    t.datetime "date"
    t.string "title"
    t.string "series_title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_pco_plans_on_organization_id"
    t.index ["pco_service_type_id"], name: "index_pco_plans_on_pco_service_type_id"
  end

  create_table "pco_service_types", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.string "pco_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_pco_service_types_on_organization_id"
  end

  create_table "pco_song_tags", force: :cascade do |t|
    t.bigint "pco_song_id"
    t.bigint "pco_tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pco_song_id"], name: "index_pco_song_tags_on_pco_song_id"
    t.index ["pco_tag_id"], name: "index_pco_song_tags_on_pco_tag_id"
  end

  create_table "pco_songs", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.string "title"
    t.string "pco_id"
    t.integer "ccli"
    t.text "themes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "hidden", default: false
    t.index ["organization_id"], name: "index_pco_songs_on_organization_id"
  end

  create_table "pco_tags", force: :cascade do |t|
    t.string "pco_id"
    t.string "source"
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "planning_center_tokens", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.string "token", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_planning_center_tokens_on_organization_id"
    t.index ["user_id"], name: "index_planning_center_tokens_on_user_id"
  end

  create_table "set_planner_plan_songs", force: :cascade do |t|
    t.bigint "set_planner_plan_id"
    t.bigint "pco_song_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pco_song_id"], name: "index_set_planner_plan_songs_on_pco_song_id"
    t.index ["set_planner_plan_id"], name: "index_set_planner_plan_songs_on_set_planner_plan_id"
  end

  create_table "set_planner_plans", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "start_date"
    t.integer "number_of_weeks"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "spotify_tokens", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.string "token", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_spotify_tokens_on_organization_id"
    t.index ["user_id"], name: "index_spotify_tokens_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "uuid", default: -> { "uuid_generate_v4()" }, null: false
    t.string "account_token"
    t.datetime "account_token_expires"
  end

end
