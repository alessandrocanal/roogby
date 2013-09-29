class TeamsController < ApplicationController

  def show
    @team = Team.find(params[:id])
    @div_match_title = "Matches by season"
    @div_stats_title = "Statistics by season"
    @div_stats_rank = "Statistics rank by season"

    m = Match.new

    ctsm = CompetitionsTeamsSeasonsMetric.new

    ctm = CompetitionsTeamsMetric.new


    if !session[:season_id].blank?
      @div_match_title = "Matches in "+session[:season_id]
      @matches = m.team_matches(params[:id], session[:season_id])
      @div_stats_title = "Stats of "+session[:season_id]
      @stats = ctsm.team_stats(params[:id], session[:season_id])
      @div_stats_rank = "Stats rank of "+session[:season_id]
      @stats_rank = ctm.team_stats(params[:id], session[:season_id])

    else
      @matches = m.team_matches(params[:id], "all")
      @stats = ctsm.team_stats(params[:id], "all")
      @stats_rank = ctm.team_stats(params[:id], "all")
    end

    render :layout => 'team'
  end
end
