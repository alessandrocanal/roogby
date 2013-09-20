class CompetitionsPlayersMetric < ActiveRecord::Base
  attr_accessible :competition_id, :metric_id, :season_id, :player_id, :quantity, :rank
end
