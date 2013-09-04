class CreateRankings < ActiveRecord::Migration
  def change
    create_table :rankings do |t|
      t.references :team_id
      t.references :season_id
      t.references :competition_id
      t.integer :round
      t.integer :rank
      t.integer :points
      t.integer :against
      t.integer :bonus
      t.integer :drawn
      t.integer :for
      t.integer :losingbonus
      t.integer :lost
      t.integer :played
      t.integer :points
      t.integer :pointsdiff
      t.integer :triesagainst
      t.integer :triesbonus
      t.integer :triesfor
      t.integer :won
      t.timestamps
    end
  end
end
