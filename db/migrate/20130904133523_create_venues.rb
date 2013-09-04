class CreateVenues < ActiveRecord::Migration
  def change
    create_table :venues do |t|
      t.string :name
      t.integer :capacity
      t.float :latitude
      t.float :longitude
      t.string :address
      t.string :city
      t.string :country
      t.string :affiliation
      t.timestamps
    end
  end
end
