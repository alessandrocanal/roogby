class CompetitionsPlayersMetric < ActiveRecord::Base

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
      stats = CompetitionsPlayersMetric.includes(:metric, :competition).where("player_id=? AND season_id=?", player_id, season_id).order("competition_id DESC, metrics.kind ASC, rank ASC, metric_id ASC")
    else
      stats = CompetitionsPlayersMetric.includes(:metric, :competition).where("player_id=?", player_id).order("season_id DESC, competition_id DESC, metrics.kind ASC, rank ASC, metric_id ASC")
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
        metric["kind"] = s.metric.kind
        competition[s.competition.name] << metric
        response[s.season_id] = competition

      elsif response[s.season_id][s.competition.name].blank?
        response[s.season_id][s.competition.name] = Array.new
        metric = Hash.new
        metric[s.metric.metric] = s.quantity
        metric["rank"] = s.rank
        metric["kind"] = s.metric.kind

        response[s.season_id][s.competition.name] << metric
      else
        metric = Hash.new
        metric[s.metric.metric] = s.quantity
        metric["rank"] = s.rank
        metric["kind"] = s.metric.kind
        response[s.season_id][s.competition.name] << metric

      end
    end
    response
    #end

  end

  def competitions_best_and_worst_players_stats(competition_id, season_id)
    #Rails.cache.fetch("competitions_best_and_worst_players_stats_"+competition_id.to_s+"_"+season_id.to_s, :expires_in => 7.days) do
    response = Hash.new
    if season_id != "all"
      stats = CompetitionsPlayersMetric.includes(:metric, :player).where("competition_id=? AND season_id=? AND rank=1", competition_id, season_id).order("metrics.kind ASC, metric_id ASC")
    else
      stats = CompetitionsPlayersMetric.includes(:metric, :player).where("competition_id=? AND rank=1", competition_id).order("season_id DESC, metrics.kind ASC,metric_id ASC")
    end
    stats.each do |s|
      #Rails.logger.debug("RESP--------->#{s.to_yaml}")
      if response[s.season_id].blank?
        response[s.season_id] = Array.new
        #Rails.logger.debug("Comp------>#{s.competition.name}")

        metric = Hash.new
        metric[s.metric.metric] = s.quantity
        metric["player_id"] = s.player_id
        metric["player"] = s.player.name rescue "NA"
        metric["kind"] = s.metric.kind
        response[s.season_id] << metric
      else
        metric = Hash.new
        metric[s.metric.metric] = s.quantity
        metric["player_id"] = s.player_id
        metric["player"] = s.player.name rescue "NA"
        metric["kind"] = s.metric.kind
        response[s.season_id] << metric

      end
    end
    response
    #end

  end
end
