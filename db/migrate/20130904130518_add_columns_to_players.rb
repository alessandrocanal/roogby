class AddColumnsToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :date_of_birth, :date
    add_column :players, :weight, :integer
    add_column :players, :heigth, :integer
  end
end
