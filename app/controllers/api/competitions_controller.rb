class Api::CompetitionsController < ApplicationController
  def websearch
    c = Competition.new
    response = c.typeheadsearch_competition

    respond_to do |format|
      format.json {render :json => response}
    end
  end
end
