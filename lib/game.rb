require 'csv'

class Game
  def initialize(game_info)
    @away_goals = game_info[:away_goals]
    @home_goals = game_info[:home_goals]
  end
end
