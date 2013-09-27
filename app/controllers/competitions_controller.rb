class CompetitionsController < ApplicationController

  def show
    @competition = Competition.find(params[:id])

    m = Match.new

    @matches = m.competition_matches(params[:id], 2013)
    render :layout => 'competition'
  end
end
