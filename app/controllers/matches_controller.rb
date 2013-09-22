class MatchesController < ApplicationController

  def show

    m = Match.new
    #Rails.logger.debug("id------->#{params[:id]}")
    @match = m.show_match(params[:id])

    mps = MatchesPlayersStatistic.new
    @home_team_lineup = mps.match_lineup(params[:id],@match.home_team.id)
    @away_team_lineup = mps.match_lineup(params[:id],@match.away_team.id)

    me = MatchesEvent.new
    @match_events = me.match_events(params[:id])

    render :layout => 'match'
  end
end
