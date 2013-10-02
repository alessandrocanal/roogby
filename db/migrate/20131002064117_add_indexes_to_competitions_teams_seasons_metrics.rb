class AddIndexesToCompetitionsTeamsSeasonsMetrics < ActiveRecord::Migration
  def change
    add_index :competitions_teams_seasons_metrics, :competition_id
    add_index :competitions_teams_seasons_metrics, :team_id
    add_index :competitions_teams_seasons_metrics, :metric_id
  end
end
