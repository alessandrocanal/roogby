class PlayersController < ApplicationController

  def show

    @player = Player.find(params[:id])

    @matches = Match.select("matches.*, teams.*").includes(:home_team, :away_team, :competition, :matches_players_statistics).where("matches_players_statistics.player_id=?", params[:id]).group("matches.id").order("matches.match_date DESC, matches.match_time DESC")
    Rails.logger.debug("MATCHES----------->#{@matches.to_yaml}")

    render :layout => 'player'
  end
end
