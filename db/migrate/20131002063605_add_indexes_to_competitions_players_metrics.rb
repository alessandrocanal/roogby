class AddIndexesToCompetitionsPlayersMetrics < ActiveRecord::Migration
  def change
    add_index :competitions_players_metrics, :competition_id
    add_index :competitions_players_metrics, :player_id
    add_index :competitions_players_metrics, :metric_id

  end
end
