class CompetitionsPlayersSeasonsMetric < ActiveRecord::Base
  attr_accessible :metric_id, :competition_id, :player_id, :position_id, :season_id, :team_id, :quantity

  validates_uniqueness_of :metric_id, :scope => [:competition_id, :player_id, :season_id]

  belongs_to :metric
  belongs_to :competition
  belongs_to :player
  belongs_to :position
  belongs_to :season
  belongs_to :team



  def player_stats(player_id,season_id)
    #Rails.cache.fetch("competitions_player_season_stats_"+player_id.to_s+"_season_"+season_id.to_s, :expires_in => 7.days) do
    response = Hash.new
    if season_id != "all"
      stats = CompetitionsPlayersSeasonsMetric.includes(:metric, :competition).where("player_id=? AND season_id=?", player_id, season_id).order("competition_id DESC, metric_id ASC")
    else
      stats = CompetitionsPlayersSeasonsMetric.includes(:metric, :competition).where("player_id=?", player_id).order("season_id DESC, competition_id DESC, metrics.kind ASC,metric_id ASC")
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
        competition[s.competition.name] << metric
        response[s.season_id] = competition

      elsif response[s.season_id][s.competition.name].blank?
        response[s.season_id][s.competition.name] = Array.new
        metric = Hash.new
        metric[s.metric.metric] = s.quantity
        metric["kind"] = s.metric.kind

        response[s.season_id][s.competition.name] << metric
      else
        metric = Hash.new
        metric[s.metric.metric] = s.quantity
        metric["kind"] = s.metric.kind
        response[s.season_id][s.competition.name] << metric

      end
    end
    Rails.logger.debug("RESP--------->#{response}")
    response
    #end
  end


end
