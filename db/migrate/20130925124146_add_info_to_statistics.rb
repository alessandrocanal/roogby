class AddInfoToStatistics < ActiveRecord::Migration
  def change
    add_column :statistics, :main, :boolean, default: false
    add_column :statistics, :category, :string
  end
end
