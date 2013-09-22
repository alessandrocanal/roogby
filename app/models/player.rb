class Player < ActiveRecord::Base
  attr_accessible :team_id, :id, :first_name, :last_name, :headshot, :date_of_birth, :height, :weight, :name, :profile, :position, :comments, :team_id

  belongs_to :team

  has_many :matches_events
  has_many :competitions_players_metrics

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
        raw['page_type'] = 'players'
        response << raw
      end
      response
    end
  end
end
