namespace :first_import do
  desc "PLAYERS IMPORT"
  task :players => :environment do
  end

  desc "TEAMS IMPORT"
  task :teams => :environment do
    require 'nokogiri'
    require 'open-uri'
    doc = Nokogiri::XML(open('http://playground.opta.net/competition.php?competition=3&season_id=2012&feed_type=RU4'))
    #Rails.logger.debug("-------------->#{doc}")
    teams = doc.xpath("seasonstats/teams/team")
      Rails.logger.debug("AAA-------------->#{teams.count}")
      teams.each do |t|
        team_id = t.xpath("@team_id")
        team_name = t.xpath("@team_name")
        new_team = Hash.new
        new_team[:name] = team_name.text
        new_team[:team_id] = team_id.text
        Rails.logger.debug("BBB-------------->#{new_team}")
        team = Team.new(new_team)
        team.save

      end
  end


end
