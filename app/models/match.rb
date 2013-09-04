class Match < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :home_team, :class_name=>"Team"
  belongs_to :away_team, :class_name=>"Team"

end
