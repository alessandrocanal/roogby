class AddDataToCompetition < ActiveRecord::Migration
  def self.up
    Competition.create :id=>3, :long_name=>"International", :name=>"International", :short_name=>"Int"
    Competition.create :id=>214, :long_name=>"Tri-Nations", :name=>"Tri-Nations"
    Competition.create :id=>"215", :long_name=>"Churchill Cup", :name=>"Churchill Cup", :short_name=>"CC"
  end
end
