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
    games_by_team(team_id).map do |game|
      game.season
    end.uniq
  end

  def games_by_team_id(team_id)
    find_team(team_id).games_played_in(@games)
  end

  def games_by_season(season, games)
    games.select do |game|
      game.season == season
    end
  end

  def games_by_team_by_season(season, team_id)
    games_by_season(season, games_by_team(team_id))
  end

  def seasons_by_win_percentage(team_id)
    win_perc_seasons = {}
    seasons_by_team(team_id).each do |season|
      win_perc_seasons[season] = find_team(team_id).win_percentage(games_by_team_by_season(season, team_id))
    end
    return win_perc_seasons
  end

  def best_season(team_id)
    highest_win_percentage = seasons_by_win_percentage(team_id).values.max
    seasons_by_win_percentage(team_id).key(highest_win_percentage)
  end

  def worst_season(team_id)
    lowest_win_percentage = seasons_by_win_percentage(team_id).values.min
    seasons_by_win_percentage(team_id).key(lowest_win_percentage)
  end

  def average_win_percentage(team_id)
    total = seasons_by_win_percentage(team_id).values.sum
    count = seasons_by_win_percentage(team_id).count
    total / count
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
