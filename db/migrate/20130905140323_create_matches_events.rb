class CreateMatchesEvents < ActiveRecord::Migration
  def change
    create_table :matches_events do |t|
      t.references :match
      t.references :player
      t.integer :minute
      t.integer :second
      t.string :event_type
      t.timestamps
    end
  end
end
