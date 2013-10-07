class CompetitionsStanding < ActiveRecord::Base
  attr_accessible :team_id, :season_id, :competition_id, :official_competition_name, :against, :bonus, :byes, :drawn, :for, :group_name, :losingbonus, :lost, :played, :points, :pointsdiff, :rank, :triesagainst, :triesbonus, :triesfor, :won

  belongs_to :competition
  belongs_to :team
  belongs_to :season

  def competition_standings(competition_id, season_id)
    #Rails.cache.fetch("competition_standings"+competition_id.to_s+"_"+season_id.to_s, :expires_in => 3.hours) do
    response = Hash.new

    if season_id != "all"
      standings = CompetitionsStanding.includes(:team).where("competition_id=? AND season_id=?", competition_id, season_id).order("group_name ASC, rank ASC")
    else
      standings = CompetitionsStanding.includes(:team).where("competition_id=?", competition_id).order("group_name ASC, rank ASC")
    end
    standings.each do |s|
      if response[s.season_id].blank?
        response[s.season_id] = Hash.new
        group = Hash.new
        group[s.group_name] = Array.new
        group[s.group_name] << s
        response[s.season_id] = group

      elsif response[s.season_id][s.group_name].blank?
        response[s.season_id][s.group_name] = Array.new

        response[s.season_id][s.group_name] << s
      else
        response[s.season_id][s.group_name] << s

      end
    end
    Rails.logger.debug("RESP----->#{response}")
    response
    # end
  end
end
