class Position < ActiveRecord::Base
  has_many :competitions_players_seasons_metrics
end
