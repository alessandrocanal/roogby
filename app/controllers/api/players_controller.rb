class Api::PlayersController < ApplicationController

  def websearch
    p = Player.new
    response = p.typeheadsearch_player

    respond_to do |format|
      format.json {render :json => response}
    end
  end
end
