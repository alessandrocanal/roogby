class Season < ActiveRecord::Base
  has_many :matches
  has_many :competitions_players_metrics
  has_many :competitions_teams_metrics
  has_many :competitions_players_seasons_metrics
  has_many :competitions_teams_seasons_metrics
  has_many :competitions_standings
end
