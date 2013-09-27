class MatchesController < ApplicationController

  def show

    m = Match.new
    #Rails.logger.debug("id------->#{params[:id]}")
    @match = m.show_match(params[:id])

    if !@match.venue.blank?
      @lat = @match.venue.latitude
      @lon = @match.venue.longitude
    else
      @lat = 0
      @lon = 0
    end

    mts = MatchesTeamsStatistic.new
    @stats = mts.retrieve_territory_stats(params[:id])
    res = Array.new

    @stats.each do |s|
      Rails.logger.debug("STATS------->#{s[:quantity]}")
      res[s[:team_id].to_i] << s[:quantity]
    end

    Rails.logger.debug("STATS------->#{res}")

    mps = MatchesPlayersStatistic.new
    @home_team_lineup = mps.match_lineup(params[:id],@match.home_team.id)
    @away_team_lineup = mps.match_lineup(params[:id],@match.away_team.id)

    me = MatchesEvent.new
    @match_events = me.match_events(params[:id])

    render :layout => 'match'
  end
end
