# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20131006095623) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "competitions", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "long_name"
    t.string   "short_name"
  end

  create_table "competitions_players_metrics", force: :cascade do |t|
    t.integer  "competition_id"
    t.integer  "player_id"
    t.integer  "metric_id"
    t.integer  "quantity"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "rank"
    t.integer  "season_id"
  end

  add_index "competitions_players_metrics", ["competition_id"], name: "index_competitions_players_metrics_on_competition_id", using: :btree
  add_index "competitions_players_metrics", ["metric_id"], name: "index_competitions_players_metrics_on_metric_id", using: :btree
  add_index "competitions_players_metrics", ["player_id"], name: "index_competitions_players_metrics_on_player_id", using: :btree

  create_table "competitions_players_seasons_metrics", force: :cascade do |t|
    t.integer  "competition_id"
    t.integer  "player_id"
    t.integer  "position_id_id"
    t.integer  "metric_id"
    t.integer  "season_id"
    t.integer  "team_id"
    t.integer  "quantity"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "competitions_players_seasons_metrics", ["competition_id"], name: "index_competitions_players_seasons_metrics_on_competition_id", using: :btree
  add_index "competitions_players_seasons_metrics", ["metric_id"], name: "index_competitions_players_seasons_metrics_on_metric_id", using: :btree
  add_index "competitions_players_seasons_metrics", ["player_id"], name: "index_competitions_players_seasons_metrics_on_player_id", using: :btree

  create_table "competitions_standings", force: :cascade do |t|
    t.integer  "team_id"
    t.integer  "season_id"
    t.integer  "competition_id"
    t.string   "official_competition_name"
    t.integer  "against"
    t.integer  "bonus"
    t.integer  "byes",                      default: 0
    t.integer  "drawn"
    t.integer  "for"
    t.string   "group_name"
    t.integer  "losingbonus"
    t.integer  "lost"
    t.integer  "played"
    t.integer  "points"
    t.integer  "pointsdiff"
    t.integer  "rank"
    t.integer  "triesagainst"
    t.integer  "triesbonus"
    t.integer  "triesfor"
    t.integer  "won"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "competitions_teams_metrics", force: :cascade do |t|
    t.integer  "competition_id"
    t.integer  "team_id"
    t.integer  "metric_id"
    t.decimal  "quantity",       precision: 8, scale: 3
    t.integer  "rank"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "season_id"
  end

  add_index "competitions_teams_metrics", ["competition_id"], name: "index_competitions_teams_metrics_on_competition_id", using: :btree
  add_index "competitions_teams_metrics", ["metric_id"], name: "index_competitions_teams_metrics_on_metric_id", using: :btree
  add_index "competitions_teams_metrics", ["team_id"], name: "index_competitions_teams_metrics_on_team_id", using: :btree

  create_table "competitions_teams_seasons_metrics", force: :cascade do |t|
    t.integer  "competition_id"
    t.integer  "team_id"
    t.integer  "metric_id"
    t.integer  "season_id"
    t.decimal  "quantity",       precision: 8, scale: 3
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "competitions_teams_seasons_metrics", ["competition_id"], name: "index_competitions_teams_seasons_metrics_on_competition_id", using: :btree
  add_index "competitions_teams_seasons_metrics", ["metric_id"], name: "index_competitions_teams_seasons_metrics_on_metric_id", using: :btree
  add_index "competitions_teams_seasons_metrics", ["team_id"], name: "index_competitions_teams_seasons_metrics_on_team_id", using: :btree

  create_table "matches", force: :cascade do |t|
    t.time     "match_time"
    t.date     "match_date"
    t.integer  "home_team_id"
    t.integer  "home_team_result"
    t.integer  "away_team_id"
    t.integer  "away_team_result"
    t.integer  "referee_id"
    t.integer  "season_id"
    t.integer  "competition_id"
    t.integer  "round"
    t.integer  "round_type_id"
    t.integer  "stage"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "venue_id"
  end

  add_index "matches", ["away_team_id"], name: "index_matches_on_away_team_id", using: :btree
  add_index "matches", ["home_team_id"], name: "index_matches_on_home_team_id", using: :btree

  create_table "matches_events", force: :cascade do |t|
    t.integer  "match_id"
    t.integer  "player_id"
    t.integer  "minute"
    t.integer  "second"
    t.string   "event_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "team_id"
  end

  add_index "matches_events", ["match_id"], name: "index_matches_events_on_match_id", using: :btree
  add_index "matches_events", ["player_id"], name: "index_matches_events_on_player_id", using: :btree

  create_table "matches_players_statistics", force: :cascade do |t|
    t.integer  "match_id"
    t.integer  "player_id"
    t.integer  "team_id"
    t.integer  "position_id"
    t.integer  "statistic_id"
    t.decimal  "quantity",     precision: 8, scale: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "matches_players_statistics", ["match_id"], name: "index_matches_players_statistics_on_match_id", using: :btree
  add_index "matches_players_statistics", ["player_id"], name: "index_matches_players_statistics_on_player_id", using: :btree
  add_index "matches_players_statistics", ["team_id"], name: "index_matches_players_statistics_on_team_id", using: :btree

  create_table "matches_teams_statistics", force: :cascade do |t|
    t.integer  "match_id"
    t.integer  "team_id"
    t.integer  "statistic_id"
    t.decimal  "quantity",     precision: 8, scale: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "matches_teams_statistics", ["match_id"], name: "index_matches_teams_statistics_on_match_id", using: :btree
  add_index "matches_teams_statistics", ["statistic_id"], name: "index_matches_teams_statistics_on_statistic_id", using: :btree
  add_index "matches_teams_statistics", ["team_id"], name: "index_matches_teams_statistics_on_team_id", using: :btree

  create_table "metrics", force: :cascade do |t|
    t.string   "metric"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "kind",       default: 0
    t.integer  "percentage", default: 0
  end

  create_table "players", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "date_of_birth"
    t.integer  "weight"
    t.integer  "heigth"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "team_id"
    t.string   "headshot"
    t.text     "profile"
    t.string   "position"
    t.text     "comments"
  end

  create_table "positions", force: :cascade do |t|
    t.string   "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rankings", force: :cascade do |t|
    t.integer  "team_id_id"
    t.integer  "season_id_id"
    t.integer  "competition_id_id"
    t.integer  "round"
    t.integer  "rank"
    t.integer  "points"
    t.integer  "against"
    t.integer  "bonus"
    t.integer  "drawn"
    t.integer  "for"
    t.integer  "losingbonus"
    t.integer  "lost"
    t.integer  "played"
    t.integer  "pointsdiff"
    t.integer  "triesagainst"
    t.integer  "triesbonus"
    t.integer  "triesfor"
    t.integer  "won"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "referees", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "seasons", force: :cascade do |t|
    t.integer  "season"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "statistics", force: :cascade do |t|
    t.string   "statistic"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "main",       default: false
    t.string   "category"
    t.boolean  "percentage", default: false
    t.integer  "kind",       default: 1
  end

  create_table "teams", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "jersey"
    t.string   "color"
  end

  create_table "teams_venues", id: false, force: :cascade do |t|
    t.integer "team_id"
    t.integer "venue_id"
  end

  add_index "teams_venues", ["team_id", "venue_id"], name: "index_teams_venues_on_team_id_and_venue_id", using: :btree

  create_table "venues", force: :cascade do |t|
    t.string   "name"
    t.integer  "capacity"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "address"
    t.string   "city"
    t.string   "country"
    t.string   "affiliation"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
