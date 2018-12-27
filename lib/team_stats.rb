module TeamStats

  def test_module
    "THIS MODULE WORKS!"
  end

  def find_team(team_id)
    @teams.find do |team|
      team.team_id == team_id
    end
  end

  def team_info(id)
    team_hash = Hash.new
    team_hash[id] = find_team(id).provide_info
  end

  def seasons_by_team(team_id)
    find_games_by_team_id(team_id).map do |game|
      game.season
    end.uniq
  end

  def games_by_team_id(team_id, games = @games) #returns game_team instance
    find_team(team_id).games_played_in(games)
  end

  def find_games_by_team_id(team_id, games = @games)
    games.select do |game|
      game.away_team_id == team_id || game.home_team_id == team_id
    end
  end


  def games_by_team_by_season(season, team_id)
    find_games_by_team_id(team_id, all_games_by_season[season])
  end

  def most_goals_scored(team_id) #this uses game_teams, not games
    max_goals = games_by_team_id(team_id).max_by do |game_team|
      game_team.goals
    end
    return max_goals.goals.to_i
  end

  def fewest_goals_scored(team_id) #this uses game_teams, not games
    min_goals = games_by_team_id(team_id).min_by do |game_team|
      game_team.goals
    end
    return min_goals.goals.to_i
  end

  def biggest_team_blowout(team_id)
    team = find_team(team_id)
    games_won = team.games_won(@games)
    game_with_biggest_team_blowout = games_won.max_by do |game|
      game.score_difference
    end
    game_with_biggest_team_blowout.score_difference
  end

  def worst_loss(team_id)
    team = find_team(team_id)
    games_lost = team.games_lost(@games)
    game_with_worst_loss = games_lost.max_by do |game|
      game.score_difference
    end
    game_with_worst_loss.score_difference
  end
end
