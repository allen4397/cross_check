require 'csv'

class Game
  attr_reader :season
  def initialize(game_info)
    @away_goals = game_info[:away_goals].to_i
    @home_goals = game_info[:home_goals].to_i
    @season = game_info[:season]
  end

  def total_score
    @away_goals + @home_goals
  end


end
