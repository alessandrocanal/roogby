class MatchesPlayersStatistic < ActiveRecord::Base
  attr_accessible :statistic_id, :player_id, :quantity, :position_id, :match_id, :team_id

  belongs_to :match
  belongs_to :player

  def match_lineup(match_id, team_id)
    #Rails.cache.fetch("match_lineup_"+match_id.to_s+"_team_"+team_id.to_s, :expires_in => 7.day) do
      lineup = MatchesPlayersStatistic.select("position_id,players.name, players.id").includes(:player).where("match_id=? AND matches_players_statistics.team_id=?", match_id, team_id).group("position_id").order("matches_players_statistics.id")
      response = Array.new

      lineup.each do |l|
        response << {:position_id=>l.position_id, :name=>l.player.name, :player_id=>l.player.id}
      end
      #Rails.logger.debug("LINEUP------>#{response}")
      response
    #end
  end
end
