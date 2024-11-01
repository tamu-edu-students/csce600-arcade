# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2024_10_31_005736) do
  create_table "aesthetics", force: :cascade do |t|
    t.integer "game_id"
    t.string "font", default: "Verdana, sans-serif"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "colors"
    t.json "labels"
  end

  create_table "bees", force: :cascade do |t|
    t.string "letters", limit: 7
    t.date "play_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "dashboards", force: :cascade do |t|
    t.integer "user_id"
    t.integer "game_id"
    t.date "played_on"
    t.integer "score"
    t.integer "streak_count", default: 0
    t.boolean "streak_record", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_dashboards_on_game_id"
    t.index ["user_id", "game_id", "played_on"], name: "index_dashboards_on_user_id_and_game_id_and_played_on", unique: true
    t.index ["user_id"], name: "index_dashboards_on_user_id"
  end

  create_table "games", force: :cascade do |t|
    t.string "name"
    t.string "game_path"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "single_score_per_day", default: false
  end

  create_table "roles", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "game_id"
    t.index ["game_id"], name: "index_roles_on_game_id"
    t.index ["user_id"], name: "index_roles_on_user_id"
  end

  create_table "settings", force: :cascade do |t|
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "active_roles"
    t.integer "page_contrast", default: 100
    t.boolean "game_font_casing", default: true
    t.index ["user_id"], name: "index_settings_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "provider"
    t.string "github_username"
    t.string "spotify_username"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["github_username"], name: "index_users_on_github_username", unique: true
    t.index ["spotify_username"], name: "index_users_on_spotify_username", unique: true
  end

  create_table "wordle_valid_guesses", force: :cascade do |t|
    t.string "word"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "wordle_valid_solutions", force: :cascade do |t|
    t.string "word"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "wordles", force: :cascade do |t|
    t.date "play_date"
    t.string "word"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["play_date"], name: "index_wordles_on_play_date", unique: true
  end

  add_foreign_key "dashboards", "games", on_delete: :cascade
  add_foreign_key "dashboards", "users", on_delete: :cascade
  add_foreign_key "roles", "games"
  add_foreign_key "roles", "users"
  add_foreign_key "settings", "users"
end
