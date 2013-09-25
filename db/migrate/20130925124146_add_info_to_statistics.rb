class AddInfoToStatistics < ActiveRecord::Migration
  def change
    add_column :statistics, :main, :boolean, :default=>0
    add_column :statistics, :category, :string
  end
end
