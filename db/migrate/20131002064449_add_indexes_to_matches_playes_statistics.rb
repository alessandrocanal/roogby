class AddIndexesToMatchesPlayesStatistics < ActiveRecord::Migration
  def change
    add_index :matches_players_statistics, :player_id
    add_index :matches_players_statistics, :match_id
    add_index :matches_players_statistics, :team_id
  end
end
