class CompetitionsTeamsMetric < ActiveRecord::Base
  attr_accessible :competition_id, :metric_id, :season_id, :team_id, :quantity, :rank

  belongs_to :competition
  belongs_to :team
  belongs_to :season
  belongs_to :metric

  validates_uniqueness_of :metric_id, :scope => [:competition_id, :season_id, :team_id]

  def last_teams_stats(metric_id, limit)
    #Rails.cache.fetch("last_teams_stats_"+metric_id.to_s, :expires_in => 7.days) do
    response = CompetitionsTeamsMetric.includes(:team, :competition).where("metric_id=?",metric_id).order("season_id DESC, competition_id DESC, rank ASC").limit(limit)
    response
    #end
  end

  def team_stats(team_id, season_id)
    #Rails.cache.fetch("competition_single_team_stats_ranking_"+team_id.to_s+"_"+season_id.to_s, :expires_in => 7.days) do
    response = Hash.new
    if season_id != "all"
      stats = CompetitionsTeamsMetric.includes(:metric, :competition).where("team_id=? AND season_id=?", team_id, season_id).order("competition_id DESC, rank ASC,metric_id ASC")
    else
      stats = CompetitionsTeamsMetric.includes(:metric, :competition).where("team_id=?", team_id).order("season_id DESC, competition_id DESC, rank ASC,metric_id ASC")
    end
    stats.each do |s|
      if response[s.season_id].blank?
        response[s.season_id] = Hash.new
        #Rails.logger.debug("Comp------>#{s.competition.name}")
        competition = Hash.new
        competition[s.competition.name] = Array.new
        metric = Hash.new
        metric[s.metric.metric] = s.quantity
        metric["rank"] = s.rank
        metric["kind"] = s.metric.kind
        metric["percentage"] = s.metric.percentage
        competition[s.competition.name] << metric
        response[s.season_id] = competition

      elsif response[s.season_id][s.competition.name].blank?
        response[s.season_id][s.competition.name] = Array.new
        metric = Hash.new
        metric[s.metric.metric] = s.quantity
        metric["rank"] = s.rank
        metric["kind"] = s.metric.kind
        metric["percentage"] = s.metric.percentage
        response[s.season_id][s.competition.name] << metric
      else
        metric = Hash.new
        metric[s.metric.metric] = s.quantity
        metric["rank"] = s.rank
        metric["kind"] = s.metric.kind
        metric["percentage"] = s.metric.percentage
        response[s.season_id][s.competition.name] << metric

      end

    end
    #Rails.logger.debug("RESP------->#{response}")
    response
    #end#
  end

  def competitions_for_sitemap
    #Rails.cache.fetch("competitions_for_sitemap", :expires_in => 1.day) do
    response = Hash.new
    competitions = CompetitionsTeamsMetric.includes(:competition).group("season_id, competitions.id").order("season_id DESC")
    competitions.each do |c|
      if response[c.season_id].blank?
        response[c.season_id] = Array.new
        competition = Hash.new
        competition["name"] = c.competition.name
        competition["id"] = c.competition.id
        response[c.season_id] << competition
      else
        competition = Hash.new
        competition["name"] = c.competition.name
        competition["id"] = c.competition.id
        response[c.season_id] << competition
      end
    end
    Rails.logger.debug("RESP------->#{response}")
    response
    #end
  end


  def competition_best_and_worst_teams_stats(competition_id, season_id)
    #Rails.cache.fetch("competition_best_and_worst_teams_stats_"+competition_id.to_s+"_"+season_id.to_s, :expires_in => 7.days) do
    response = Hash.new
    if season_id != "all"
      stats = CompetitionsTeamsMetric.includes(:metric, :team).where("competition_id=? AND season_id=? AND rank=1", competition_id, season_id).order("metrics.kind ASC, metric_id ASC")
    else
      stats = CompetitionsTeamsMetric.includes(:metric, :team).where("competition_id=? AND rank=1", competition_id).order("season_id DESC, metrics.kind ASC,metric_id ASC")
    end
    stats.each do |s|
      if response[s.season_id].blank?
        response[s.season_id] = Array.new

        metric = Hash.new
        metric[s.metric.metric] = s.quantity
        metric["team"] = s.team.name rescue "NA"
        metric["team_id"] = s.team_id
        metric["kind"] = s.metric.kind
        metric["percentage"] = s.metric.percentage
        response[s.season_id] << metric

      else
        metric = Hash.new
        metric[s.metric.metric] = s.quantity
        metric["team"] = s.team.name rescue "NA"
        metric["team_id"] = s.team_id
        metric["kind"] = s.metric.kind
        metric["percentage"] = s.metric.percentage
        response[s.season_id] << metric
      end
    end
    Rails.logger.debug("RESP------->#{response}")
    response
    #end#

  end
end
