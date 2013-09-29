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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130929125544) do

  create_table "competitions", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "long_name"
    t.string   "short_name"
  end

  create_table "competitions_players_metrics", :force => true do |t|
    t.integer  "competition_id"
    t.integer  "player_id"
    t.integer  "metric_id"
    t.integer  "quantity"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "rank"
    t.integer  "season_id"
  end

  create_table "competitions_players_seasons_metrics", :force => true do |t|
    t.integer  "competition_id"
    t.integer  "player_id"
    t.integer  "position_id"
    t.integer  "metric_id"
    t.integer  "season_id"
    t.integer  "team_id"
    t.integer  "quantity"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "competitions_teams_metrics", :force => true do |t|
    t.integer  "competition_id"
    t.integer  "team_id"
    t.integer  "metric_id"
    t.integer  "quantity"
    t.integer  "rank"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "season_id"
  end

  create_table "competitions_teams_seasons_metrics", :force => true do |t|
    t.integer  "competition_id"
    t.integer  "team_id"
    t.integer  "metric_id"
    t.integer  "season_id"
    t.decimal  "quantity",       :precision => 8, :scale => 3
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
  end

  create_table "matches", :force => true do |t|
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
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "venue_id"
  end

  add_index "matches", ["away_team_id"], :name => "index_matches_on_away_team_id"
  add_index "matches", ["home_team_id"], :name => "index_matches_on_home_team_id"

  create_table "matches_events", :force => true do |t|
    t.integer  "match_id"
    t.integer  "player_id"
    t.integer  "minute"
    t.integer  "second"
    t.string   "event_type"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "team_id"
  end

  create_table "matches_players_statistics", :force => true do |t|
    t.integer  "match_id"
    t.integer  "player_id"
    t.integer  "team_id"
    t.integer  "position_id"
    t.integer  "statistic_id"
    t.decimal  "quantity",     :precision => 8, :scale => 4
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
  end

  create_table "matches_teams_statistics", :force => true do |t|
    t.integer  "match_id"
    t.integer  "team_id"
    t.integer  "statistic_id"
    t.decimal  "quantity",     :precision => 8, :scale => 4
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
  end

  create_table "metrics", :force => true do |t|
    t.string   "metric"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.integer  "kind",       :default => 0
    t.integer  "percentage", :default => 0
  end

  create_table "players", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.date     "date_of_birth"
    t.integer  "weight"
    t.integer  "height"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "team_id"
    t.string   "headshot"
    t.text     "profile"
    t.string   "position"
    t.text     "comments"
  end

  create_table "positions", :force => true do |t|
    t.string   "position"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "rankings", :force => true do |t|
    t.integer  "team_id"
    t.integer  "season_id"
    t.integer  "competition_id"
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
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "referees", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "seasons", :force => true do |t|
    t.integer  "season"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "statistics", :force => true do |t|
    t.string   "statistic"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "main",       :default => false
    t.string   "category"
    t.boolean  "percentage", :default => false
    t.integer  "kind",       :default => 1
  end

  create_table "teams", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "jersey"
    t.string   "color"
  end

  create_table "teams_venues", :id => false, :force => true do |t|
    t.integer "team_id"
    t.integer "venue_id"
  end

  add_index "teams_venues", ["team_id", "venue_id"], :name => "index_teams_venues_on_team_id_and_venue_id"

  create_table "venues", :force => true do |t|
    t.string   "name"
    t.integer  "capacity"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "address"
    t.string   "city"
    t.string   "country"
    t.string   "affiliation"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

end
