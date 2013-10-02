class AddIndexesToCompetitionsTeamsMetrics < ActiveRecord::Migration
  def change
    add_index :competitions_teams_metrics, :competition_id
    add_index :competitions_teams_metrics, :team_id
    add_index :competitions_teams_metrics, :metric_id
  end
end
