class MatchesEvent < ActiveRecord::Base
  attr_accessible :match_id, :minute, :second, :player_id, :team_id, :event_type

  belongs_to :match
  belongs_to :player


  def match_events(match_id)
    Rails.cache.fetch("match_events"+match_id.to_s, :expires_in => 7.day) do
      response = MatchesEvent.includes(:player).where("match_id=?", match_id)

      response

    end
  end
end
