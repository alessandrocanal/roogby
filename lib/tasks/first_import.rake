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

  desc "MATCHES IMPORT"
  task :matches => :environment do
    require 'nokogiri'
    require 'open-uri'

    docs = Array.new
    docs[0] = 'http://playground.opta.net/competition.php?competition=3&season_id=2012&feed_type=RU1'
    docs[1] = 'http://playground.opta.net/competition.php?competition=214&season_id=2013&feed_type=RU1'
    docs[2] = 'http://playground.opta.net/competition.php?competition=3&season_id=2013&feed_type=RU1'
    docs[3] = 'http://playground.opta.net/competition.php?competition=215&season_id=2011&feed_type=RU1'
    docs[4] = 'http://playground.opta.net/competition.php?competition=3&season_id=2012&feed_type=RU1'

    docs.each do |d|
      doc = Nokogiri::XML(open(d))

      fixtures = doc.xpath("fixtures/fixture")
      fixtures.each do |f|
        new_match = Hash.new
        new_match[:id] = f.xpath("@id").text
        new_match[:match_date] = Date.parse(f.xpath("@game_date").text)
        new_match[:match_time] = f.xpath("@time").text
        new_match[:season_id] = f.xpath("@season_id").text
        new_match[:competition_id] = f.xpath("@comp_id").text
        new_match[:round] = f.xpath("@round").text
        new_match[:round_type_id] = f.xpath("@round_type_id").text
        new_match[:stage] = f.xpath("@stage").text

        teams = f.xpath("team")
        teams.each do |t|
          if t.xpath("@home_or_away").text == "home"
            new_match[:home_team_id] = t.xpath("@team_id").text
            new_match[:home_team_result] = t.xpath("@score").text
          elsif t.xpath("@home_or_away").text == "away"
            new_match[:away_team_id] = t.xpath("@team_id").text
            new_match[:away_team_result] = t.xpath("@score").text
          end
        end

        m = Match.new(new_match)
        if m.valid?
          m.save
        end
      end
    end
  end

  desc "ADDITIONAL PLAYERS INFO IMPORT"
  task :additional_players_info => :environment do
    require 'nokogiri'
    require 'open-uri'

    docs = Array.new

    docs[0] = 'http://playground.opta.net/competition.php?competition=3&season_id=2012&feed_type=RU10'
    docs[1] = 'http://playground.opta.net/competition.php?competition=214&season_id=2013&feed_type=RU10'
    docs[2] = 'http://playground.opta.net/competition.php?competition=3&season_id=2013&feed_type=RU10'
    docs[3] = 'http://playground.opta.net/competition.php?competition=215&season_id=2011&feed_type=RU10'
    docs[4] = 'http://playground.opta.net/competition.php?competition=3&season_id=2012&feed_type=RU10'

    docs.each do |d|
      doc = Nokogiri::XML(open(d))
      teams = doc.xpath("RU10_Profile/team")

      teams.each do |t|
        team_id = t.xpath("@id").text
        Rails.logger.debug("TEAM ID ---->#{team_id}")
        players = t.xpath("players")
        players.each do |p|
          if !p.xpath("@player_id").text.blank?
            new_player = Hash.new
            new_player[:id] = p.xpath("@player_id").text
            new_player[:name] = p.xpath("@player_known_name").text
            new_player[:date_of_birth] = p.xpath("@birth_date").text
            new_player[:weight] = p.xpath("@height").text
            new_player[:height] = p.xpath("@weight").text
            new_player[:first_name] = p.xpath("@player_first_name").text
            new_player[:last_name] = p.xpath("@player_last_name").text
            new_player[:profile] = p.xpath("@profile").text
            new_player[:position] = p.xpath("@position").text
            new_player[:comments] = p.xpath("@comments").text
            new_player[:team_id] = team_id
            player = Player.where("id=?",p.xpath("@player_id").text)
            if player.blank?
              p = Player.new(new_player)
              if p.valid?
                p.save
              end
            else
              Rails.logger.debug("PLAYER FOUND------->#{player.to_yaml}")
              player.first.update_attributes(new_player)
            end

          end

        end
      end
    end
  end

end
