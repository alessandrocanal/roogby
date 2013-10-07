class CreateCompetitionsStandings < ActiveRecord::Migration
  def change
    create_table :competitions_standings do |t|
      t.references :team
      t.references :season
      t.references :competition
      t.string :official_competition_name
      t.integer :against
      t.integer :bonus
      t.integer :byes, :default=>0
      t.integer :drawn
      t.integer :for
      t.string :group_name
      t.integer :losingbonus
      t.integer :lost
      t.integer :played
      t.integer :points
      t.integer :pointsdiff
      t.integer :rank
      t.integer :triesagainst
      t.integer :triesbonus
      t.integer :triesfor
      t.integer :won
      t.timestamps
    end
  end
end
