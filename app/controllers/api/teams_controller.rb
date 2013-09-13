class Api::TeamsController < ApplicationController

  def websearch
    t = Team.new
    response = t.typeheadsearch_team

    respond_to do |format|
      format.json {render :json => response}
    end
  end
end
