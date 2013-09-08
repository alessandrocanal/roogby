class RemoveFieldToTeams < ActiveRecord::Migration
  def up
    remove_column :teams, :team_id
  end

  def down
    add_column :teams, :team_id, :integer
  end
end
