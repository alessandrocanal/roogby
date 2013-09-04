class CreateJoinTableTeamVenue < ActiveRecord::Migration
  def change
    create_table :teams_venues, :id => false do |t|
      t.references :team, :venue
    end

    add_index :teams_venues, [:team_id, :venue_id]
  end
end
