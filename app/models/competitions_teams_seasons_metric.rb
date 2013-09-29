class CompetitionsTeamsSeasonsMetric < ActiveRecord::Base
  attr_accessible :metric_id, :competition_id, :season_id, :team_id, :quantity

  validates_uniqueness_of :metric_id, :scope => [:competition_id, :team_id, :season_id]

  belongs_to :metric
  belongs_to :competition
  belongs_to :season
  belongs_to :team

  def team_stats(team_id, season_id)
    #Rails.cache.fetch("competitions_team_season_stats_"+team_id.to_s+"_season_"+season_id.to_s, :expires_in => 7.days) do
    response = Hash.new
    if season_id != "all"
      stats = CompetitionsTeamsSeasonsMetric.includes(:metric, :competition).where("team_id=? AND season_id=?", team_id, season_id).order("competition_id DESC, metrics.kind ASC,metric_id ASC")
    else
      stats = CompetitionsTeamsSeasonsMetric.includes(:metric, :competition).where("team_id=?", team_id).order("season_id DESC, competition_id DESC, metrics.kind ASC,metric_id ASC")
    end
    stats.each do |s|
      #Rails.logger.debug("RESP--------->#{s.to_yaml}")
      if response[s.season_id].blank?
        response[s.season_id] = Hash.new
        #Rails.logger.debug("Comp------>#{s.competition.name}")
        competition = Hash.new
        competition[s.competition.name] = Array.new
        metric = Hash.new
        metric[s.metric.metric] = s.quantity
        metric["kind"] = s.metric.kind
        metric["percentage"] = s.metric.percentage
        competition[s.competition.name] << metric
        response[s.season_id] = competition

      elsif response[s.season_id][s.competition.name].blank?
        response[s.season_id][s.competition.name] = Array.new
        metric = Hash.new
        metric[s.metric.metric] = s.quantity
        metric["kind"] = s.metric.kind
        metric["percentage"] = s.metric.percentage
        response[s.season_id][s.competition.name] << metric
      else
        metric = Hash.new
        metric[s.metric.metric] = s.quantity
        metric["kind"] = s.metric.kind
        metric["percentage"] = s.metric.percentage
        response[s.season_id][s.competition.name] << metric

      end
    end
    Rails.logger.debug("RESP--------->#{response}")
    response
    #end
  end
end
