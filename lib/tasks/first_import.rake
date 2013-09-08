namespace :first_import do
  desc "PLAYERS IMPORT"
  task :players => :environment do
    require 'nokogiri'
    require 'open-uri'
    doc = Nokogiri::XML(open('http://playground.opta.net/competition.php?competition=3&season_id=2012&feed_type=RU4'))
    teams = doc.xpath("seasonstats/teams/team")
    teams.each do |t|
      team_id = t.xpath("@team_id").text
      Rails.logger.debug("---------------->#{team_id}")
      players = t.xpath("players/player")
      players.each do |p|
        new_player=Hash.new
        new_player[:team_id] = team_id

        new_player[:id]=p.xpath("@player_id").text
        new_player[:first_name] = p.xpath("@player_first_name").text
        new_player[:last_name] = p.xpath("@player_last_name").text
        new_player[:name] = p.xpath("@player_known_name").text
        new_player[:headshot] = new_player[:name]+".jpg"
        date_of_birth = p.xpath("@dob").text
        if (date_of_birth != '0000-00-00')
          Rails.logger.debug("---------------->#{date_of_birth}")
          new_player[:date_of_birth] = Date.parse(date_of_birth)
        end


        new_player[:height] = p.xpath("@height").text
        new_player[:weight] = p.xpath("@weight").text

        player = Player.new(new_player)
        if player.valid?
          player.save
        end
      end
    end
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
        new_team[:id] = team_id.text
        Rails.logger.debug("BBB-------------->#{new_team}")
        team = Team.new(new_team)
        if team.valid?
          team.save
        end
      end
  end


end
