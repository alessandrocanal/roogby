class AddCommentsToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :comments, :text
  end
end
