class CompetitionsPlayersMetric < ActiveRecord::Base
  attr_accessible :competition_id, :metric_id, :season_id, :player_id, :quantity, :rank

  belongs_to :competition
  belongs_to :player
  belongs_to :season
  belongs_to :metric

  validates_uniqueness_of :metric_id, :scope => [:competition_id, :season_id, :player_id]

  def last_players_stats(metric_id, limit)
    #Rails.cache.fetch("last_players_stats_"+metric_id.to_s, :expires_in => 7.days) do
      response = CompetitionsPlayersMetric.includes(:player, :competition).where("metric_id=?",metric_id).order("season_id DESC, competition_id DESC, rank ASC").limit(limit)
      response
    #end
  end

  def player_stats_rank(player_id, season_id)
    #Rails.cache.fetch("player_stats_rank_"+player_id.to_s+"_"+season_id.to_s, :expires_in => 7.days) do
    response = Hash.new
    if season_id != "all"
      stats = CompetitionsPlayersMetric.includes(:metric, :competition).where("player_id=? AND season_id=?", player_id, season_id).order("competition_id DESC, metric_id ASC")
    else
      stats = CompetitionsPlayersMetric.includes(:metric, :competition).where("player_id=?", player_id).order("season_id DESC, competition_id DESC, metrics.kind ASC,metric_id ASC")
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
        metric["rank"] = s.rank
        competition[s.competition.name] << metric
        response[s.season_id] = competition

      elsif response[s.season_id][s.competition.name].blank?
        response[s.season_id][s.competition.name] = Array.new
        metric = Hash.new
        metric[s.metric.metric] = s.quantity
        metric["rank"] = s.rank

        response[s.season_id][s.competition.name] << metric
      else
        metric = Hash.new
        metric[s.metric.metric] = s.quantity
        metric["rank"] = s.rank
        response[s.season_id][s.competition.name] << metric

      end
    end
    response
    #end

  end
end
