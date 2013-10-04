class CompetitionsController < ApplicationController

  def index

    render :layout => 'competition'
  end

  def show
    @competition = Competition.find(params[:id])

    m = Match.new
    cpm = CompetitionsPlayersMetric.new
    ctm = CompetitionsTeamsMetric.new


    if !session[:season_id].blank?
      @matches = m.competition_matches(params[:id], session[:season_id])
      @stats_rank = ctm.competition_teams_stats(params[:id], session[:season_id])
    else
      @matches = m.competition_matches(params[:id], "all")
      @stats_rank = ctm.competition_teams_stats(params[:id], "all")
    end


    render :layout => 'competition'
  end
end
