class AddHeadshotToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :headshot, :string
  end
end
