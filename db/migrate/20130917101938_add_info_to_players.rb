class AddInfoToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :profile, :text
    add_column :players, :position, :string
  end
end
