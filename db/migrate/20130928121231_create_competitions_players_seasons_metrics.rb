class CreateCompetitionsPlayersSeasonsMetrics < ActiveRecord::Migration
  def change
    create_table :competitions_players_seasons_metrics do |t|
      t.references :competition
      t.references :player
      t.references :position_id
      t.references :metric
      t.references :season
      t.references :team
      t.integer :quantity
      t.timestamps
    end
  end
end
