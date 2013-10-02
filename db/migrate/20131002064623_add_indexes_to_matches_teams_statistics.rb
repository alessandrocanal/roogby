class AddIndexesToMatchesTeamsStatistics < ActiveRecord::Migration
  def change
    add_index :matches_teams_statistics, :statistic_id
    add_index :matches_teams_statistics, :match_id
    add_index :matches_teams_statistics, :team_id
  end
end
