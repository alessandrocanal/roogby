class TeamsController < ApplicationController

  def index
    t = Team.new

    @teams = t.teams_for_sitemap
    render :layout => 'team'

  end

  def show
    @team = Team.find(params[:id])
    @div_match_title = "Matches by season"
    @div_stats_title = "Competitions stats"
    @div_stats_rank = "Competitions stats rank"
    if !@team.jersey.blank?
      @img_url = "#{@team.id}"+"/"+"#{@team.jersey}"
    else
      @img_url = 'jersey.png'
    end

    m = Match.new

    ctsm = CompetitionsTeamsSeasonsMetric.new

    ctm = CompetitionsTeamsMetric.new


    if !session[:season_id].blank?
      @div_match_title = "Matches in "+session[:season_id]
      @matches = m.team_matches(params[:id], session[:season_id])
      @div_stats_title = "Competitions stats in  "+session[:season_id]
      @stats = ctsm.team_stats(params[:id], session[:season_id])
      @div_stats_rank = "Competitions stats rank in "+session[:season_id]
      @stats_rank = ctm.team_stats(params[:id], session[:season_id])

    else
      @matches = m.team_matches(params[:id], "all")
      @stats = ctsm.team_stats(params[:id], "all")
      @stats_rank = ctm.team_stats(params[:id], "all")
    end

    render :layout => 'team'
  end
end
