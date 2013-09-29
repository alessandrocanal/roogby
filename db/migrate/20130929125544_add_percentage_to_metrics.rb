class AddPercentageToMetrics < ActiveRecord::Migration
  def change
    add_column :metrics, :percentage, :integer, :default=>0
  end
end
