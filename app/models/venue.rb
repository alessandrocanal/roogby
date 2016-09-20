class Venue < ActiveRecord::Base
  validates :id, :uniqueness => true
  has_and_belongs_to_many :teams

  has_many :matches
end
