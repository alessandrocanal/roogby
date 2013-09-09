class AddDataToSeason < ActiveRecord::Migration
  def self.up
    Season.create :id=> 2011 , :season => "2011"
    Season.create :id=> 2012 , :season => "2012"
    Season.create :id=> 2013 , :season => "2013"
  end
end
