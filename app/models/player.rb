class Player < ActiveRecord::Base
  attr_accessible :team_id, :id, :first_name, :last_name, :headshot, :date_of_birth, :height, :weight, :name

  validates :id, :uniqueness => true
end
