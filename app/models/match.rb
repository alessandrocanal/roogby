class Match < ActiveRecord::Base
  attr_accessible :id, :match_date, :match_time, :home_team_id, :home_team_result, :away_team_id, :away_team_result, :referee_id, :season_id, :competition_id, :round, :round_type_id, :stage, :venue_id

  validates :id, :uniqueness => true

  belongs_to :home_team, :class_name=>"Team", :foreign_key => :home_team_id
  belongs_to :away_team, :class_name=>"Team", :foreign_key => :away_team_id

  belongs_to :venue
  belongs_to :season
  belongs_to :competition
  belongs_to :referee

  has_many :matches_players_statistics
  has_many :matches_events

  def last_matches(limit)
    #Rails.cache.fetch("last_matches_"+id.to_s, :expires_in => 1.hour) do
      response = Match.includes(:home_team, :away_team, :competition).order("match_date DESC").limit(limit)
      response
    #end
  end

  def show_match(id)
    #Rails.cache.fetch("match_"+id.to_s, :expires_in => 7.day) do
      response = Match.includes(:home_team, :away_team, :competition, :venue).where("matches.id=?", id).first

      #Rails.logger.debug("RESP----------->#{response}")
      response
    #end
  end

end
