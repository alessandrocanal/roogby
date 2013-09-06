class CreateStatistics < ActiveRecord::Migration
  def change
    create_table :statistics do |t|
      t.string :statistic
      t.timestamps
    end
  end
end
