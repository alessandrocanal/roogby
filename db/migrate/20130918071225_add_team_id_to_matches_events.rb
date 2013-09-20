class AddTeamIdToMatchesEvents < ActiveRecord::Migration
  def change
    add_column :matches_events, :team_id, :integer
  end
end
