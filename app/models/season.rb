class Season < ActiveRecord::Base
  attr_accessible :id, :season

  has_many :matches
  has_many :competitions_players_metrics
  has_many :competitions_teams_metrics
end
