class CreateCompetitionsTeamsSeasonsMetrics < ActiveRecord::Migration
  def change
    create_table :competitions_teams_seasons_metrics do |t|
      t.references :competition
      t.references :team
      t.references :metric
      t.references :season
      t.decimal :quantity, :precision => 8, :scale => 3
      t.timestamps
    end
  end
end
