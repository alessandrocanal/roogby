class AddFurtherDataToStatistics < ActiveRecord::Migration
  def change
    Statistic.create :statistic=>"scrums_success", :main=>1, :category=>"Open play", :percentage=>1, :kind=>2
  end
end
