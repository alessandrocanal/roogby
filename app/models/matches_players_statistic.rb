class MatchesPlayersStatistic < ActiveRecord::Base
  attr_accessible :statistic_id, :player_id, :quantity, :position_id, :match_id, :team_id

  belongs_to :match
end
