class AddSeasonIdToCompetitionsPlayersMetrics < ActiveRecord::Migration
  def change
    add_column :competitions_players_metrics, :season_id, :integer
  end
end
