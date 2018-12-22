module TeamStats

  def test_module
    "THIS MODULE WORKS!"
  end

  def team_info(id)
    found_team = @teams.find do |team|
      team.team_id == id
    end
    team_hash = Hash.new
    team_hash[id] = found_team.provide_info
  end

  def seasons_by_team(team_id)
    games_by_team(team_id).map do |game|
      game.season
    end.uniq
  end

  def games_by_team(team_id)
    games_by_team = []
    @games.each do |game|
      if game.away_team_id == team_id
        games_by_team << game
      elsif game.home_team_id == team_id
        games_by_team << game
      end
    end
    return games_by_team
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
      win_perc_seasons[season] = win_percentage(team_id, games_by_team_by_season(season, team_id))
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

  def most_goals_scored(team_id)
    max_goals = games_by_team_id(team_id).max_by do |game|
      game.goals
    end
    return max_goals.goals.to_i
  end

  def fewest_goals_scored(team_id)
    min_goals = games_by_team_id(team_id).min_by do |game|
      game.goals
    end
    return min_goals.goals.to_i
  end

end
