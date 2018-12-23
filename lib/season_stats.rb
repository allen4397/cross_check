module SeasonStats

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

  def season_summary(season_id, team_id)
    team = find_team(team_id)

    games = games_by_team_by_season(season_id, team_id)
    preseason = group_games_by_season_type("P", games)
    reg_season = group_games_by_season_type("R", games)

    preseason_hash = { :win_percentage => team.win_percentage(preseason),
                        :goals_scored => team.goals_scored(preseason),
                        :goals_against => get_opponent_goals(team_id, preseason)}

    reg_season_hash = { :win_percentage => team.win_percentage(reg_season),
                        :goals_scored => team.goals_scored(reg_season),
                        :goals_against => get_opponent_goals(team_id, reg_season)}

    {:preseason => preseason_hash,
    :regular_season => reg_season_hash}
  end


    def biggest_bust(season_id)
      regular_season = group_games_by_season_type("R", games_by_season[season_id])
      preseason = group_games_by_season_type("P", games_by_season[season_id])
      largest_decrease_in_percentage = @teams.max_by do |team|
        team.win_percentage(preseason)/team.win_percentage(regular_season)
      end
      largest_decrease_in_percentage.team_name
    end

    def biggest_surprise(season_id)
      regular_season = group_games_by_season_type("R", games_by_season[season_id])
      preseason = group_games_by_season_type("P", games_by_season[season_id])
      largest_increase_in_percentage = @teams.max_by do |team|
        team.win_percentage(regular_season)/team.win_percentage(preseason)
      end
      largest_increase_in_percentage.team_name
    end



end
