class AddSeasonIdToCompetitionsTeamsMetrics < ActiveRecord::Migration
  def change
    add_column :competitions_teams_metrics, :season_id, :integer
  end
end
