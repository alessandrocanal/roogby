class Match < ActiveRecord::Base
  attr_accessible :id, :match_date, :match_time, :home_team_id, :home_team_result, :away_team_id, :away_team_result, :referee_id, :season_id, :competition_id, :round, :round_type_id, :stage, :venue_id

  validates :id, :uniqueness => true

  belongs_to :home_team, :class_name=>"Team", :foreign_key => :home_team_id
  belongs_to :away_team, :class_name=>"Team", :foreign_key => :away_team_id

  belongs_to :venue
  belongs_to :season
  belongs_to :competition
  belongs_to :referee

  has_many :matches_players_statistics
  has_many :matches_events
  has_many :competitions_players_seasons_metrics
  has_many :competitions_teams_seasons_metrics

  def last_matches(limit)
    #Rails.cache.fetch("last_matches_"+id.to_s, :expires_in => 1.hour) do
      response = Match.includes(:home_team, :away_team, :competition).order("match_date DESC").limit(limit)
      response
    #end
  end

  def show_match(id)
    #Rails.cache.fetch("match_"+id.to_s, :expires_in => 7.day) do
      response = Match.includes(:home_team, :away_team, :competition, :venue).where("matches.id=?", id).first

      #Rails.logger.debug("RESP----------->#{response}")
      response
    #end
  end

  def competition_matches(competition_id, season_id)
    #Rails.cache.fetch("match_"+id.to_s, :expires_in => 1.hour) do
      response = Match.includes(:home_team, :away_team).where("competition_id=? AND season_id=?", competition_id, season_id).order("round ASC")

      #Rails.logger.debug("RESP----------->#{response}")
      response
    #end
  end

  def player_matches(player_id, season_id)
    #Rails.cache.fetch("player_matches_"+team_id.to_s+"_"+season_id, :expires_in => 1.hour) do
    response = Hash.new
    if season_id != "all"
      matches = Match.select("matches.*, teams.*").includes(:home_team, :away_team, :competition, :matches_players_statistics).where("matches_players_statistics.player_id=? AND matches.season_id=?", player_id, season_id).group("matches.id").order("matches.match_date DESC, matches.match_time DESC")
    else
      matches = Match.select("matches.*, teams.*").includes(:home_team, :away_team, :competition, :matches_players_statistics).where("matches_players_statistics.player_id=?", player_id).group("matches.id").order("matches.match_date DESC, matches.match_time DESC")
    end
    matches.each do |m|
      if response[m.season_id].blank?
        response[m.season_id] = Array.new
        response[m.season_id] << m
      else
        response[m.season_id] << m


      end
    end
    response
    #end
  end

  def team_matches(team_id, season_id)
    #Rails.cache.fetch("team_matches_"+team_id.to_s+"_"+season_id, :expires_in => 1.hour) do
    response = Hash.new
    if season_id != "all"
      matches = Match.includes(:home_team, :away_team).where("(home_team_id=? OR away_team_id=?) AND season_id=?", team_id, team_id, season_id).order("match_date DESC, match_time DESC")
    else
      matches = Match.includes(:home_team, :away_team).where("(home_team_id=? OR away_team_id=?)", team_id, team_id).order("match_date DESC, match_time DESC")
    end
    matches.each do |m|
      if response[m.season_id].blank?
        response[m.season_id] = Array.new
        response[m.season_id] << m
      else
        response[m.season_id] << m


      end
    end
    Rails.logger.debug("MATCHES---->#{response}")
    response
    #end
  end

end
