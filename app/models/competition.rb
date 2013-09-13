class Competition < ActiveRecord::Base
  attr_accessible :id, :name, :short_name, :long_name

  validates :id, :uniqueness => true

  def typeheadsearch_competition
    Rails.cache.fetch("typeaheadsearch_competition", :expires_in => 1.day) do
      competitions = Competition.order("name ASC")
      response = Array.new
      competitions.each do |c|
        raw = Hash.new
        raw['value_id'] = c.id
        raw['name'] = c.name.to_s
        raw['page_type'] = 'competitions'
        response << raw
      end
      response
    end
  end
end
