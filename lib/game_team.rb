class GameTeam
  attr_reader :game_id, :team_id, :goals, :shots, :won

  def initialize(game_team_info)
    @game_id = game_team_info[:game_id]
    @team_id = game_team_info[:team_id]
    @won = game_team_info[:won]
    @goals = game_team_info[:goals]
    @shots = game_team_info[:shots]
  end

end
