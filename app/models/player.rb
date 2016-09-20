class Player < ActiveRecord::Base
  belongs_to :team

  has_many :matches_events
  has_many :competitions_players_metrics
  has_many :competitions_players_seasons_metrics

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

  def players_for_sitemap
    #Rails.cache.fetch("players_for_sitemap", :expires_in => 1.day) do
    response = Hash.new
    players = Player.includes(:team).order("team_id ASC, last_name ASC")
    players.each do |p|
      if p.team.nil?
        response["team name unavailable"] = Array.new
        response["team name unavailable"] << p
      elsif response[p.team.name].blank?
        response[p.team.name] = Array.new
        response[p.team.name] << p
      else
        response[p.team.name] << p
      end
    end

    Rails.logger.debug("RESP----->#{response}")
    response
    #end

  end
end
