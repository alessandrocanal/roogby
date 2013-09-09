class Team < ActiveRecord::Base
  attr_accessible :name, :id
  has_and_belongs_to_many :venues

  validates :id, :uniqueness => true

end
