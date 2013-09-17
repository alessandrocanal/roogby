class CreateCompetitionsTeamsMetrics < ActiveRecord::Migration
  def change
    create_table :competitions_teams_metrics do |t|
      t.references :competition
      t.references :team
      t.references :metric
      t.integer :quantity
      t.integer :rank
      t.timestamps
    end
  end
end
