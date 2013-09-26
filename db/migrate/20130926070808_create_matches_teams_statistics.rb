class CreateMatchesTeamsStatistics < ActiveRecord::Migration
  def change
    create_table :matches_teams_statistics do |t|
      t.references :match
      t.references :team
      t.references :statistic
      t.decimal :quantity, :precision => 8, :scale => 4
      t.timestamps
    end
  end
end
