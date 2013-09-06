class CreateMatchesPlayersStatistics < ActiveRecord::Migration
  def change
    create_table :matches_players_statistics do |t|
      t.references :match_id
      t.references :player_id
      t.references :team_id
      t.references :position_id
      t.references :statistic_id
      t.integer :quantity
      t.timestamps
    end
  end
end
