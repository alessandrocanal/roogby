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

  desc "VENUES IMPORT"
  task :venues => :environment do
    require 'nokogiri'
    require 'open-uri'

    docs = Array.new
    docs[0] = 'http://playground.opta.net/competition.php?competition=3&season_id=2012&feed_type=RU45'
    docs[1] = 'http://playground.opta.net/competition.php?competition=3&season_id=2012&feed_type=RU45'
    docs[2] = 'http://playground.opta.net/competition.php?competition=3&season_id=2013&feed_type=RU45'
    docs[3] = 'http://playground.opta.net/competition.php?competition=215&season_id=2011&feed_type=RU45'
    docs[4] = 'http://playground.opta.net/competition.php?competition=3&season_id=2012&feed_type=RU45'

    docs.each do |d|
      doc = Nokogiri::XML(open(d))
      stadia = doc.xpath("OptaFeed/OptaDocument/stadium")
      new_venue = Hash.new
      stadia.each do |s|
        new_venue[:id] = s.xpath("@venue_id").text
        new_venue[:capacity] = s.xpath("@capacity").text
        new_venue[:name] = s.xpath("@venue").text
        address = s.xpath("address")
        new_venue[:address] = address.xpath("@street").text
        new_venue[:city] = address.xpath("@city").text
        new_venue[:country] = address.xpath("@country").text
        affiliation = s.xpath("affiliation")
        new_venue[:affiliation] = affiliation.xpath("@country").text
        gps = s.xpath("gps")
        new_venue[:latitude] = gps.xpath("@latitude").text
        new_venue[:longitude] = gps.xpath("@longitude").text
        venue = Venue.new(new_venue)
        if venue.valid?
          venue.save
          teams = s.xpath("team")
          teams.each do |t|
            team = Team.where("id=?",t.xpath("@id").text)
            Rails.logger.debug("VENUE-------->#{team}")
            if team.blank?
              new_team = Hash.new
              new_team[:id] = t.xpath("@id").text
              new_team[:name] = t.xpath("@name").text

              nt = Team.new(new_team)
              if nt.valid?
                nt.save

                team = Team.where("id=?",t.xpath("@id").text)
                venue.teams = team
              end
            else
              venue.teams = team
            end
          end
        end
      end
    end
  end


end
