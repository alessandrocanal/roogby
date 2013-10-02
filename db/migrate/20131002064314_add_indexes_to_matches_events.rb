class AddIndexesToMatchesEvents < ActiveRecord::Migration
  def change
    add_index :matches_events, :player_id
    add_index :matches_events, :match_id
  end
end
