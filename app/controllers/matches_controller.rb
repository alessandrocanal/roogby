class MatchesController < ApplicationController

  def index
    render :layout => 'match'
  end

  def show

    m = Match.new
    #Rails.logger.debug("id------->#{params[:id]}")
    @match = m.show_match(params[:id])

    if !@match.venue.blank?
      @lat = @match.venue.latitude
      @lon = @match.venue.longitude
      @venue = @match.venue.name+" - "+@match.venue.address+" ("+@match.venue.city+")" rescue "NA"
    else
      @lat = 0
      @lon = 0
      @venue = ""
    end

    mts = MatchesTeamsStatistic.new
    @stats = mts.retrieve_territory_stats(params[:id])
    @res = Hash.new

    @stats.each do |s|
      Rails.logger.debug("STATS------->#{s.to_yaml}")
      if @res[s[:team_id]].blank?
        @res[s[:team_id]] = Array.new
      end
      @res[s[:team_id]] << (s[:quantity] * 100).to_i
    end

    Rails.logger.debug("STATS 2------->#{@res}")

    mps = MatchesPlayersStatistic.new
    @home_team_lineup = mps.match_lineup(params[:id],@match.home_team.id)
    @away_team_lineup = mps.match_lineup(params[:id],@match.away_team.id)

    me = MatchesEvent.new
    @match_events = me.match_events(params[:id])

    render :layout => 'match'
  end

  def live

    render :layout => 'match'
  end
end
