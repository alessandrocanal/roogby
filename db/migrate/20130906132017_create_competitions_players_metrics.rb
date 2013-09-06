class CreateCompetitionsPlayersMetrics < ActiveRecord::Migration
  def change
    create_table :competitions_players_metrics do |t|
      t.references :competition_id
      t.references :player_id
      t.references :metric_id
      t.integer :quantity
      t.timestamps
    end
  end
end
