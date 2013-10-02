class AddIndexesToCompetitionsPlayersSeasonsMetrics < ActiveRecord::Migration
  def change
    add_index :competitions_players_seasons_metrics, :competition_id
    add_index :competitions_players_seasons_metrics, :player_id
    add_index :competitions_players_seasons_metrics, :metric_id

  end
end
