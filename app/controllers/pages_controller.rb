class PagesController < ApplicationController
  respond_to :html, :json

  def home
    @opengraph = Hash.new
    @opengraph['title'] = "Roogby - googling rugby's world"
    @opengraph['type'] = 'sport'
    @opengraph['image'] = ""
    @opengraph['url'] = root_url

    @seasons = Season.order("id DESC")
    render :layout => 'home'
  end

  def traffic_redirection
    if !params[:page_kind].blank?
      if params[:page_kind] == 'players'
        @player = Player.find(params['value_id'])
        redirect_to @player
      elsif params[:page_kind] == 'teams'
      elsif params[:page_kind] == 'competitions'
      end
    else

    end
  end
end
