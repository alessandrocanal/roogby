class AddVenueIdToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :venue_id, :integer
  end
end
