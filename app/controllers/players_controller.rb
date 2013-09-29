class PlayersController < ApplicationController

  def show

    @player = Player.find(params[:id])

    #@matches = Match.select("matches.*, teams.*").includes(:home_team, :away_team, :competition, :matches_players_statistics).where("matches_players_statistics.player_id=?", params[:id]).group("matches.id").order("matches.match_date DESC, matches.match_time DESC")
    #Rails.logger.debug("MATCHES----------->#{@matches.to_yaml}")

    m = Match.new
    cpsm = CompetitionsPlayersSeasonsMetric.new

    @div_matches = "Matches played"
    @div_competition_stats = "Competitions stats"

    if !session[:season_id].blank?
      @div_matches = "Matches played in "+session[:season_id]
      @div_competition_stats = "Competitions stats in "+session[:season_id]
      @matches = m.player_matches(params[:id], session[:season_id])
      @stats = cpsm.player_stats(params[:id], session[:season_id])
    else
      @matches = m.player_matches(params[:id], "all")
      @stats = cpsm.player_stats(params[:id], "all")
    end

    render :layout => 'player'
  end
end
