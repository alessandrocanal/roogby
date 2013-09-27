class MatchesTeamsStatistic < ActiveRecord::Base
  attr_accessible :statistic_id, :quantity, :match_id, :team_id

  belongs_to :match
  belongs_to :team

  validates_uniqueness_of :statistic_id, :scope => [:match_id, :team_id]

  def retrieve_territory_stats(match_id)
    response = MatchesTeamsStatistic.where("match_id=? AND statistic_id IN (209,213,214)",match_id).order("statistic_id ASC")
    response
  end
end
