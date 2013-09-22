class CompetitionsTeamsMetric < ActiveRecord::Base
  attr_accessible :competition_id, :metric_id, :season_id, :team_id, :quantity, :rank

  belongs_to :competition
  belongs_to :team
  belongs_to :season
  belongs_to :metric

  validates_uniqueness_of :metric_id, :scope => [:competition_id, :season_id, :team_id]

  def last_teams_stats(metric_id, limit)
    #Rails.cache.fetch("last_players_stats_"+metric_id.to_s, :expires_in => 7.days) do
    response = CompetitionsTeamsMetric.includes(:team, :competition).where("metric_id=?",metric_id).order("season_id DESC, competition_id DESC, rank ASC").limit(limit)
    response
    #end
  end
end
