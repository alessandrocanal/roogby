class PagesController < ApplicationController
  respond_to :html, :json

  def home
    @opengraph = Hash.new
    @opengraph['title'] = "Roogby - googling rugby's world"
    @opengraph['type'] = 'sport'
    @opengraph['image'] = ""
    @opengraph['url'] = root_url

    @seasons = Season.all
    render :layout => 'home'
  end
end
