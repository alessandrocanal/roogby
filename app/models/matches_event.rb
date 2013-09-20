class MatchesEvent < ActiveRecord::Base
  attr_accessible :match_id, :minute, :second, :player_id, :team_id, :event_type
end
