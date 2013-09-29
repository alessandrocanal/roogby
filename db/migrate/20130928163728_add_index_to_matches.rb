class AddIndexToMatches < ActiveRecord::Migration
  def self.up
    add_index :matches, :home_team_id
    add_index :matches, :away_team_id
  end

  def self.down
    remove_index :matches, :column => :home_team_id
    remove_index :matches, :column => :away_team_id
  end
end
