class Venue < ActiveRecord::Base
  attr_accessible :id, :body, :name, :capacity, :latitude, :longitude, :address, :city, :country, :affiliation

  validates :id, :uniqueness => true
  has_and_belongs_to_many :teams
end
