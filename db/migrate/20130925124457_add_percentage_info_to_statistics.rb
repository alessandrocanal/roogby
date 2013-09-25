class AddPercentageInfoToStatistics < ActiveRecord::Migration
  def change
    add_column :statistics, :percentage, :boolean, :default=>0
  end
end
