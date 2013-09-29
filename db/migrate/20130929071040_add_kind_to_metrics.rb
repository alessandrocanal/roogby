class AddKindToMetrics < ActiveRecord::Migration
  def change
    add_column :metrics, :kind, :integer, :default=>0
  end
end
