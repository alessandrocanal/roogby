class ChangeDataTypeToMatchesPlayersStatistics < ActiveRecord::Migration
  def self.up
    change_table :matches_players_statistics do |t|
      t.change :quantity, :decimal, :precision => 8, :scale => 4
    end
  end

  def down
  end
end
