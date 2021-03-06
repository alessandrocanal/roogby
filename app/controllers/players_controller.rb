class PlayersController < ApplicationController

  def index
    p = Player.new

    @players = p.players_for_sitemap
    render :layout => 'player'
  end

  def show

    @player = Player.find(params[:id])
    if !@player.headshot.blank?
      @img_url = "#{@player.team_id}" +"/players/"+ "#{@player.headshot}"
    else
      @img_url = "player.png"
    end
    #@matches = Match.select("matches.*, teams.*").includes(:home_team, :away_team, :competition, :matches_players_statistics).where("matches_players_statistics.player_id=?", params[:id]).group("matches.id").order("matches.match_date DESC, matches.match_time DESC")
    #Rails.logger.debug("MATCHES----------->#{@matches.to_yaml}")

    m = Match.new
    cpm = CompetitionsPlayersMetric.new
    cpsm = CompetitionsPlayersSeasonsMetric.new

    @div_matches = "Matches played"
    @div_competition_stats = "Competitions stats"
    @div_stats_rank = "Competitions stats rank"

    if !session[:season_id].blank?
      @div_matches = "Matches played in "+session[:season_id]
      @div_competition_stats = "Competitions stats in "+session[:season_id]
      @div_stats_rank = "Competitions stats rank in "+session[:season_id]
      @matches = m.player_matches(params[:id], session[:season_id])
      @stats_rank = cpm.player_stats_rank(params[:id], session[:season_id])
      @stats = cpsm.player_stats(params[:id], session[:season_id])
    else
      @matches = m.player_matches(params[:id], "all")
      @stats = cpsm.player_stats(params[:id], "all")
      @stats_rank = cpm.player_stats_rank(params[:id], "all")
    end

    render :layout => 'player'
  end
end
