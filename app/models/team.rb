class Team < ActiveRecord::Base
  attr_accessible :name, :id
  has_and_belongs_to_many :venues
  has_many :players

  validates :id, :uniqueness => true

  def typeheadsearch_team
    Rails.cache.fetch("typeaheadsearch_yeam", :expires_in => 1.day) do
      teams = Team.order("name ASC")
      response = Array.new
      teams.each do |t|
        raw = Hash.new
        raw['value_id'] = t.id
        raw['name'] = t.name.to_s
        raw['page_type'] = 'teams'
        response << raw
      end
      response
    end
  end
end
