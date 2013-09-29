class Position < ActiveRecord::Base
  # attr_accessible :title, :body

  has_many :competitions_players_seasons_metrics
end
