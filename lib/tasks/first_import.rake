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
        new_match[:venue_id] = f.xpath("@venue_id").text

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

  desc "MATCH EVENTS IMPORT"
  task :matches_events => :environment do
    require 'nokogiri'
    require 'open-uri'

    docs = Array.new

    docs[0] = 'http://playground.opta.net/?game_id=11559&feed_type=ru7'
    docs[1] = 'http://playground.opta.net/?game_id=2478&feed_type=ru7'
    docs[2] = 'http://playground.opta.net/?game_id=2479&feed_type=ru7'
    docs[3] = 'http://playground.opta.net/?game_id=2480&feed_type=ru7'
    docs[4] = 'http://playground.opta.net/?game_id=2481&feed_type=ru7'
    docs[5] = 'http://playground.opta.net/?game_id=2482&feed_type=ru7'
    docs[6] = 'http://playground.opta.net/?game_id=2483&feed_type=ru7'
    docs[7] = 'http://playground.opta.net/?game_id=2484&feed_type=ru7'
    docs[8] = 'http://playground.opta.net/?game_id=2485&feed_type=ru7'
    docs[9] = 'http://playground.opta.net/?game_id=2486&feed_type=ru7'
    docs[10] = 'http://playground.opta.net/?game_id=2487&feed_type=ru7'
    docs[11] = 'http://playground.opta.net/?game_id=2488&feed_type=ru7'
    docs[12] = 'http://playground.opta.net/?game_id=2489&feed_type=ru7'
    docs[13] = 'http://playground.opta.net/?game_id=8779&feed_type=ru7'
    docs[14] = 'http://playground.opta.net/?game_id=8786&feed_type=ru7'
    docs[15] = 'http://playground.opta.net/?game_id=8791&feed_type=ru7'
    docs[16] = 'http://playground.opta.net/?game_id=8797&feed_type=ru7'
    docs[17] = 'http://playground.opta.net/?game_id=8799&feed_type=ru7'
    docs[18] = 'http://playground.opta.net/?game_id=5986&feed_type=ru7'
    docs[19] = 'http://playground.opta.net/?game_id=5981&feed_type=ru7'
    docs[20] = 'http://playground.opta.net/?game_id=5982&feed_type=ru7'
    docs[21] = 'http://playground.opta.net/?game_id=1627&feed_type=ru7'
    docs[22] = 'http://playground.opta.net/?game_id=11560&feed_type=ru7'
    docs[23] = 'http://playground.opta.net/?game_id=11561&feed_type=ru7'

    docs.each do |d|
      doc = Nokogiri::XML(open(d))

      match = doc.xpath("RRML")
      match_id = match.xpath("@id").text

      events = doc.xpath("RRML/Events/Event")
      events.each do |e|
        match_event = Hash.new
        match_event[:match_id] = match_id
        match_event[:player_id] = e.xpath("@player_id").text
        match_event[:minute] = e.xpath("@minute").text
        match_event[:second] = e.xpath("@second").text
        match_event[:team_id] = e.xpath("@team_id").text
        match_event[:event_type] = e.xpath("@type").text

        me = MatchesEvent.new(match_event)

        if me.valid?
          me.save
        end
      end
    end
  end

  desc "COMPETIIONS PLAYERS METRICS IMPORT"
  task :competitions_players_metrics => :environment do
    require 'nokogiri'
    require 'open-uri'

    metrics = Metric.all

    docs = Array.new
    docs[0] = 'http://playground.opta.net/competition.php?competition=3&season_id=2012&feed_type=RU3'
    docs[1] = 'http://playground.opta.net/competition.php?competition=214&season_id=2013&feed_type=RU3'
    docs[2] = 'http://playground.opta.net/competition.php?competition=3&season_id=2013&feed_type=RU3'
    docs[3] = 'http://playground.opta.net/competition.php?competition=215&season_id=2011&feed_type=RU3'
    docs[4] = 'http://playground.opta.net/competition.php?competition=3&season_id=2012&feed_type=RU3'

    docs.each do |d|
      doc = Nokogiri::XML(open(d))

      competition = doc.xpath("seasonrankings/competition")
      competition_id = competition.xpath("@id").text
      season_id = competition.xpath("@season_id").text

      metrics.each do |m|
        Rails.logger.debug("METRICA------->#{m.metric}")
        stats = doc.xpath("seasonrankings/rankings/playerstats/"+m.metric.to_s+"/player")
        stats.each do |s|
          cpmetric = Hash.new
          cpmetric[:competition_id] = competition_id
          cpmetric[:season_id] = season_id
          cpmetric[:player_id] = s.xpath("@player_id").text
          cpmetric[:metric_id] = m.id.to_i
          cpmetric[:quantity] = s.xpath("@value").text
          cpmetric[:rank] = s.xpath("@rank").text

          cpm = CompetitionsPlayersMetric.new(cpmetric)

          if cpm.valid?
            cpm.save
          end
        end
      end
    end

  end

  desc "COMPETIIONS PLAYERS SEASONS METRICS IMPORT"
  task :competitions_players_seasons_metrics => :environment do
    require 'nokogiri'
    require 'open-uri'

    docs = Array.new
    docs[0] = 'http://playground.opta.net/competition.php?competition=3&season_id=2012&feed_type=RU4'
    docs[1] = 'http://playground.opta.net/competition.php?competition=214&season_id=2013&feed_type=RU4'
    docs[2] = 'http://playground.opta.net/competition.php?competition=3&season_id=2013&feed_type=RU4'
    docs[3] = 'http://playground.opta.net/competition.php?competition=215&season_id=2011&feed_type=RU4'
    docs[4] = 'http://playground.opta.net/competition.php?competition=3&season_id=2012&feed_type=RU4'

    docs.each do |d|
      doc = Nokogiri::XML(open(d))
      competition = doc.xpath('seasonstats/competition')
      competition_id = competition.xpath('@id').text
      season_id = competition.xpath('@season_id').text
      #Rails.logger.debug("SEASON ID----->#{season_id}")

      teams = doc.xpath('seasonstats/teams/team')
      teams.each do |t|
        team_id = t.xpath('@team_id').text
        Rails.logger.debug("TEAM ID----->#{team_id}")

        players = t.xpath('players/player')
        players.each do |p|
          player_id = p.xpath('@player_id').text
          position_id = p.xpath('@position_id').text
          Rails.logger.debug("PLAYER ID----->#{player_id}")
          playerstats = p.xpath('playerstats')
          playerstats.each do |ps|
            metrics = ps.keys
            metrics_quantity = ps.values
            Rails.logger.debug("METRICHE------>#{metrics}")
            metrics.each_with_index do |m,i|
              metric_obj = Metric.where("metric=?", m)
              if !metric_obj.blank?
                metric_id = metric_obj.first.id

                new_cpsm = Hash.new
                new_cpsm[:competition_id] = competition_id
                new_cpsm[:player_id] = player_id
                new_cpsm[:position_id] = position_id
                new_cpsm[:metric_id] = metric_id
                new_cpsm[:season_id] = season_id
                new_cpsm[:team_id] = team_id
                new_cpsm[:quantity] = metrics_quantity[i]

                cpsm = CompetitionsPlayersSeasonsMetric.new(new_cpsm)
                if cpsm.valid?
                  cpsm.save
                end
              end
            end
          end
        end
      end

    end
  end

  desc "COMPETIIONS TEAMS SEASONS METRICS IMPORT"
  task :competitions_teams_seasons_metrics => :environment do
    require 'nokogiri'
    require 'open-uri'

    docs = Array.new
    docs[0] = 'http://playground.opta.net/competition.php?competition=3&season_id=2012&feed_type=RU4'
    docs[1] = 'http://playground.opta.net/competition.php?competition=214&season_id=2013&feed_type=RU4'
    docs[2] = 'http://playground.opta.net/competition.php?competition=3&season_id=2013&feed_type=RU4'
    docs[3] = 'http://playground.opta.net/competition.php?competition=215&season_id=2011&feed_type=RU4'
    docs[4] = 'http://playground.opta.net/competition.php?competition=3&season_id=2012&feed_type=RU4'

    docs.each do |d|
      doc = Nokogiri::XML(open(d))
      competition = doc.xpath('seasonstats/competition')
      competition_id = competition.xpath('@id').text
      season_id = competition.xpath('@season_id').text
      #Rails.logger.debug("SEASON ID----->#{season_id}")

      teams = doc.xpath('seasonstats/teams/team')
      teams.each do |t|
        team_id = t.xpath('@team_id').text

        teamstats = t.xpath('teamstats')
        teamstats.each do |ts|
          metrics = ts.keys
          metrics_quantity = ts.values
          metrics.each_with_index do |m,i|
            metric_obj = Metric.where("metric=?", m)
            if !metric_obj.blank?
              metric_id = metric_obj.first.id

              new_ctsm = Hash.new
              new_ctsm[:competition_id] = competition_id
              new_ctsm[:metric_id] = metric_id
              new_ctsm[:season_id] = season_id
              new_ctsm[:team_id] = team_id
              new_ctsm[:quantity] = metrics_quantity[i]

              ctsm = CompetitionsTeamsSeasonsMetric.new(new_ctsm)
              if ctsm.valid?
                ctsm.save
              end
            end
          end

        end
      end
    end
  end

  desc "COMPETIIONS TEAMS METRICS IMPORT"
  task :competitions_teams_metrics => :environment do
    require 'nokogiri'
    require 'open-uri'

    metrics = Metric.all

    docs = Array.new
    docs[0] = 'http://playground.opta.net/competition.php?competition=3&season_id=2012&feed_type=RU3'
    docs[1] = 'http://playground.opta.net/competition.php?competition=214&season_id=2013&feed_type=RU3'
    docs[2] = 'http://playground.opta.net/competition.php?competition=3&season_id=2013&feed_type=RU3'
    docs[3] = 'http://playground.opta.net/competition.php?competition=215&season_id=2011&feed_type=RU3'
    docs[4] = 'http://playground.opta.net/competition.php?competition=3&season_id=2012&feed_type=RU3'

    docs.each do |d|
      doc = Nokogiri::XML(open(d))

      competition = doc.xpath("seasonrankings/competition")
      competition_id = competition.xpath("@id").text
      season_id = competition.xpath("@season_id").text

      metrics.each do |m|
        #Rails.logger.debug("METRICA------->#{m.metric}")
        stats = doc.xpath("seasonrankings/rankings/teamstats/"+m.metric.to_s+"/team")
        stats.each do |s|
          ctmetric = Hash.new
          ctmetric[:competition_id] = competition_id
          ctmetric[:season_id] = season_id
          ctmetric[:team_id] = s.xpath("@team_id").text
          ctmetric[:metric_id] = m.id.to_i
          ctmetric[:quantity] = s.xpath("@value").text
          ctmetric[:rank] = s.xpath("@rank").text

          ctm = CompetitionsTeamsMetric.new(ctmetric)

          if ctm.valid?
            ctm.save
          end
        end
      end
    end

  end

  desc "MATCH PLAYERS STATISTICS IMPORT"
  task :matches_players_statistics => :environment do
    require 'nokogiri'
    require 'open-uri'

    docs = Array.new

    docs[0] = 'http://playground.opta.net/?game_id=11559&feed_type=ru7'
    docs[1] = 'http://playground.opta.net/?game_id=2478&feed_type=ru7'
    docs[2] = 'http://playground.opta.net/?game_id=2479&feed_type=ru7'
    docs[3] = 'http://playground.opta.net/?game_id=2480&feed_type=ru7'
    docs[4] = 'http://playground.opta.net/?game_id=2481&feed_type=ru7'
    docs[5] = 'http://playground.opta.net/?game_id=2482&feed_type=ru7'
    docs[6] = 'http://playground.opta.net/?game_id=2483&feed_type=ru7'
    docs[7] = 'http://playground.opta.net/?game_id=2484&feed_type=ru7'
    docs[8] = 'http://playground.opta.net/?game_id=2485&feed_type=ru7'
    docs[9] = 'http://playground.opta.net/?game_id=2486&feed_type=ru7'
    docs[10] = 'http://playground.opta.net/?game_id=2487&feed_type=ru7'
    docs[11] = 'http://playground.opta.net/?game_id=2488&feed_type=ru7'
    docs[12] = 'http://playground.opta.net/?game_id=2489&feed_type=ru7'
    docs[13] = 'http://playground.opta.net/?game_id=8779&feed_type=ru7'
    docs[14] = 'http://playground.opta.net/?game_id=8786&feed_type=ru7'
    docs[15] = 'http://playground.opta.net/?game_id=8791&feed_type=ru7'
    docs[16] = 'http://playground.opta.net/?game_id=8797&feed_type=ru7'
    docs[17] = 'http://playground.opta.net/?game_id=8799&feed_type=ru7'
    docs[18] = 'http://playground.opta.net/?game_id=5986&feed_type=ru7'
    docs[19] = 'http://playground.opta.net/?game_id=5981&feed_type=ru7'
    docs[20] = 'http://playground.opta.net/?game_id=5982&feed_type=ru7'
    docs[21] = 'http://playground.opta.net/?game_id=1627&feed_type=ru7'
    docs[22] = 'http://playground.opta.net/?game_id=11560&feed_type=ru7'
    docs[23] = 'http://playground.opta.net/?game_id=11561&feed_type=ru7'

    docs.each do |d|
      doc = Nokogiri::XML(open(d))

      match = doc.xpath("RRML")
      match_id = match.xpath("@id").text

      teams = doc.xpath("RRML/TeamDetail/Team")



      teams.each do |t|
        team_id = t.xpath("@team_id").text
        players = t.xpath("Player")
        players.each do |p|
          player_id = p.xpath("@id").text
          position_id = p.xpath("@position_id").text
          stats = p.xpath("PlayerStats/PlayerStat")
          stats.each do |s|
            #Rails.logger.debug("--------->#{s.keys.first}")
            new_statistic = Hash.new
            statistic = Statistic.where("statistic=?", s.keys.first.to_s)

            if !statistic.blank?
              new_statistic[:match_id] = match_id
              new_statistic[:team_id] = team_id
              new_statistic[:player_id] = player_id
              new_statistic[:position_id] = position_id
              new_statistic[:statistic_id] = statistic.first.id
              new_statistic[:quantity] = s.values.first

              if new_statistic[:quantity] != 0 && new_statistic[:quantity] != "0" && new_statistic[:quantity] != 0.0 && new_statistic[:quantity] != "0.0" && new_statistic[:quantity] != ""
                mps = MatchesPlayersStatistic.new(new_statistic)
                if mps.valid?
                  mps.save
                end
              end
            end
          end
        end
        teams_stats = t.xpath("TeamStats/TeamStat")
        teams_stats.each do |ts|
          new_team_statistic = Hash.new
          statistic = Statistic.where("statistic=?", ts.keys.first.to_s)

          if !statistic.blank?
            new_team_statistic[:match_id] = match_id
            new_team_statistic[:team_id] = team_id

            new_team_statistic[:statistic_id] = statistic.first.id
            new_team_statistic[:quantity] = ts.values.first

            if new_team_statistic[:quantity] != 0 && new_team_statistic[:quantity] != "0" && new_team_statistic[:quantity] != 0.0 && new_team_statistic[:quantity] != "0.0" && new_team_statistic[:quantity] != ""
              mts = MatchesTeamsStatistic.new(new_team_statistic)
              if mts.valid?
                mts.save
              end
            end
          end
        end

      end

    end

  end

end
