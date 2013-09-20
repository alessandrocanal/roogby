class CompetitionsTeamsMetric < ActiveRecord::Base
  attr_accessible :competition_id, :metric_id, :season_id, :team_id, :quantity, :rank
end
