class CreateCompetitionsPlayersMetrics < ActiveRecord::Migration
  def change
    create_table :competitions_players_metrics do |t|
      t.references :competition
      t.references :player
      t.references :metric
      t.integer :quantity
      t.timestamps
    end
  end
end
