class CreateCompetitionsTeamsMetrics < ActiveRecord::Migration
  def change
    create_table :competitions_teams_metrics do |t|
      t.references :competition_id
      t.references :team_id
      t.references :metric_id
      t.integer :quantity
      t.integer :rank
      t.timestamps
    end
  end
end
