module SeasonStats

  def seasons_by_win_percentage(team_id)
    win_perc_seasons = {}
    seasons_by_team(team_id).each do |season|
      win_perc_seasons[season] = find_team(team_id).win_percentage(games_by_team_by_season(season, team_id))
    end
    return win_perc_seasons
  end

  def season_with_most_games
    highest_count = count_of_games_by_season.values.max
    count_of_games_by_season.key(highest_count).to_i
  end

  def season_with_fewest_games
    lowest_count = count_of_games_by_season.values.min
    count_of_games_by_season.key(lowest_count).to_i
  end

  def count_of_games_by_season
    game_count_by_season = {}
    all_games_by_season.each do |season, games|
      game_count_by_season[season] = games.count
    end
    return game_count_by_season
  end

  def group_games_by_season_type(type, games = @games)
    games.select do |game|
      game.type == type
    end
  end

  def group_games_by_type_season_and_team(type, season_id, team_id)
    group_games_by_season_type(type, games_by_team_by_season(season_id, team_id))
  end

  def average_goals_by_season
    average_by_season = {}
    all_games_by_season.each do |season, games|
      total_score_for_season = games.sum do |game|
        game.total_score
      end
      average_by_season[season] = (total_score_for_season.to_f/games.flatten.count).round(2)
    end
    average_by_season
  end


end
