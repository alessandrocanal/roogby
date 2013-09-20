class AddRankToCompetitionsPlayersMetrics < ActiveRecord::Migration
  def change
    add_column :competitions_players_metrics, :rank, :integer
  end
end
