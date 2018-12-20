require 'csv'

class Game
  attr_reader :venue,
              :season,
              :outcome,
              :away_team_id,
              :home_team_id,
              :type,
              :home_goals,
              :away_goals


  def initialize(game_info)
    @away_goals = game_info[:away_goals].to_i
    @home_goals = game_info[:home_goals].to_i
    @venue = game_info[:venue]
    @season = game_info[:season]
    @outcome = game_info[:outcome]
    @away_team_id = game_info[:away_team_id]
    @home_team_id = game_info[:home_team_id]
    @type = game_info[:type]
  end

  def total_score
    @away_goals + @home_goals
  end

  def score_difference
    (@away_goals - @home_goals).abs
  end

end
