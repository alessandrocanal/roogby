class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.time :match_time
      t.date :match_date
      t.references :home_team
      t.integer :home_team_result
      t.references :away_team
      t.integer :away_team_result
      t.references :referee
      t.references :season
      t.references :competition
      t.integer :round
      t.integer :round_type_id
      t.integer :stage
      t.timestamps
    end
  end
end
