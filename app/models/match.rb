class Match < ActiveRecord::Base
  attr_accessible :id, :match_date, :match_time, :home_team_id, :home_team_result, :away_team_id, :away_team_result, :referee_id, :season_id, :competition_id, :round, :round_type_id, :stage

  validates :id, :uniqueness => true

  belongs_to :home_team, :class_name=>"Team"
  belongs_to :away_team, :class_name=>"Team"

  belongs_to :venue
  belongs_to :season
  belongs_to :competition
  belongs_to :referee

end
