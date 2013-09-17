class PlayersController < ApplicationController

  def show

    @player = Player.find(params[:id])


    render :layout => 'player'
  end
end
