class Player < ActiveRecord::Base
  attr_accessible :team_id, :id, :first_name, :last_name, :headshot, :date_of_birth, :height, :weight, :name

  belongs_to :team

  validates :id, :uniqueness => true

  def typeheadsearch_player
    Rails.cache.fetch("typeaheadsearch_player", :expires_in => 1.day) do
      players = Player.joins("INNER JOIN teams ON teams.id=players.team_id").order("players.last_name ASC")
      response = Array.new
      players.each do |p|
        raw = Hash.new
        raw['value_id'] = p.id
        raw['name'] = p.last_name.to_s
        raw['name2'] = p.first_name.to_s
        raw['team'] = p.team.name.to_s
        raw['tokens'] = [p.last_name] + p.last_name.split
        response << raw
      end
      response
    end
  end
end
