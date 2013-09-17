class Season < ActiveRecord::Base
  attr_accessible :id, :season

  has_many :matches
end
