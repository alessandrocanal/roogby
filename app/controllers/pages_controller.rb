class PagesController < ApplicationController
  respond_to :html, :json

  def home
    @opengraph = Hash.new
    @opengraph['title'] = "Roogby - googling rugby's world"
    @opengraph['type'] = 'sport'
    @opengraph['image'] = ""
    @opengraph['url'] = root_url

    @seasons = Season.order("id DESC")

    @ctm = CompetitionsTeamsMetric.includes(:metric).order("RAND()").first
    m_id = @ctm.metric_id
    ctm_obj = CompetitionsTeamsMetric.new
    @teams_stats = ctm_obj.last_teams_stats(m_id,5)

    @cpm = CompetitionsPlayersMetric.includes(:metric).order("RAND()").first
    metric_id = @cpm.metric_id
    cpm_obj = CompetitionsPlayersMetric.new
    @players_stats = cpm_obj.last_players_stats(metric_id,5)

    m = Match.new
    @last_matches = m.last_matches(5)
    render :layout => 'home'
  end

  def traffic_redirection
    Rails.logger.debug("PARAMS------>#{params}")
    if !params[:page_kind].blank?
      if !params[:season].blank?
        session[:season_id] = params[:season]
      else
        session[:season_id] = ""
      end
      if params[:page_kind] == 'players'
        flash[:error] = ""
        @player = Player.find(params['value_id'])
        redirect_to @player
      elsif params[:page_kind] == 'teams'
        flash[:error] = ""
        @team = Team.find(params['value_id'])
        redirect_to @team

      elsif params[:page_kind] == 'competitions'
        flash[:error] = ""
        @competition = Competition.find(params['value_id'])
        redirect_to @competition
      end
    else
      flash[:error] = "No results match"
      redirect_to root_path
    end
  end
end
