class Team < ActiveRecord::Base
  attr_accessible :name, :team_id
  has_and_belongs_to_many :venues

end
