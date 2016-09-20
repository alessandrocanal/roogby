class AddKindToStatistics < ActiveRecord::Migration
  def change
    add_column :statistics, :kind, :integer, default: 1
  end
end
