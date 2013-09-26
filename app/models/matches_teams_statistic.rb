class MatchesTeamsStatistic < ActiveRecord::Base
  attr_accessible :statistic_id, :quantity, :match_id, :team_id

  belongs_to :match
  belongs_to :team

  validates_uniqueness_of :statistic_id, :scope => [:match_id, :team_id]
end
