class CreateMatchesPlayersStatistics < ActiveRecord::Migration
  def change
    create_table :matches_players_statistics do |t|
      t.references :match
      t.references :player
      t.references :team
      t.references :position
      t.references :statistic
      t.integer :quantity
      t.timestamps
    end
  end
end
