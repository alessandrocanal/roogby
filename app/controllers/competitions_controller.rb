class CompetitionsController < ApplicationController

  def index

    render :layout => 'competition'
  end

  def index
    c = CompetitionsTeamsMetric.new
    @competitions = c.competitions_for_sitemap

    render :layout => 'competition'
  end

  def show
    @competition = Competition.find(params[:id])
    @div_players_stats = "Players' stats"
    @div_teams_stats = "Teams' stats"
    m = Match.new
    cs = CompetitionsStanding.new
    cpm = CompetitionsPlayersMetric.new
    ctm = CompetitionsTeamsMetric.new


    if !session[:season_id].blank?
      @matches = m.competition_matches(params[:id], session[:season_id])
      @stats_rank = ctm.competition_best_and_worst_teams_stats(params[:id], session[:season_id])
      @players_stats_rank = cpm.competitions_best_and_worst_players_stats(params[:id],session[:season_id])
      @standings = cs.competition_standings(params[:id],session[:season_id])
      @div_players_stats = "The best and the worst"
      @div_teams_stats = "Best and worst teams"
    elsif !params[:season_id].blank?
      @matches = m.competition_matches(params[:id], params[:season_id])
      @stats_rank = ctm.competition_best_and_worst_teams_stats(params[:id], params[:season_id])
      @players_stats_rank = cpm.competitions_best_and_worst_players_stats(params[:id],params[:season_id])
      @standings = cs.competition_standings(params[:id],params[:season_id])
      @div_players_stats = "The best and the worst"
      @div_teams_stats = "Best and worst teams"
    else
      @matches = m.competition_matches(params[:id], "all")
      @stats_rank = ctm.competition_best_and_worst_teams_stats(params[:id], "all")
      @players_stats_rank = cpm.competitions_best_and_worst_players_stats(params[:id],"all")
      @standings = cs.competition_standings(params[:id],"all")

    end


    render :layout => 'competition'
  end
end
