class MatchesTeamsStatistic < ActiveRecord::Base
  belongs_to :match
  belongs_to :team

  validates_uniqueness_of :statistic_id, :scope => [:match_id, :team_id]

  def retrieve_territory_stats(match_id)
    response = MatchesTeamsStatistic.where("match_id=? AND statistic_id IN (208,209,211, 212, 213,214)",match_id).order("statistic_id ASC, team_id ASC")
    response
  end
end
