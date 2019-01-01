module LeagueStats

  def count_of_teams
    @teams.count
  end

  def best_offense
    best_team = @teams.max_by do |team|
      average_score_by_team_id(team.team_id)
    end
    return best_team.team_name
  end

  def worst_offense
    worst_team = @teams.min_by do |team|
      average_score_by_team_id(team.team_id)
    end
    return worst_team.team_name
  end

  def best_defense
    team_id = all_teams_opponent_averages.key(all_teams_opponent_averages.values.min)
    get_team_name_from_id(team_id)
  end

  def worst_defense
    team_id = all_teams_opponent_averages.key(all_teams_opponent_averages.values.max)
    get_team_name_from_id(team_id)
  end

  def highest_scoring_visitor
    highest_scoring_away_team = teams.max_by do |team|
      if team.games_played_as_visitor(games) != 0
        team.total_away_points(games).to_f / team.games_played_as_visitor(games)
      else
        0
      end
    end
    highest_scoring_away_team.team_name
  end

  def highest_scoring_home_team
    highest_scoring_home_team = teams.max_by do |team|
      if team.games_played_as_home_team(games) != 0
        team.total_home_points(games).to_f / team.games_played_as_home_team(games)
      else
        0
      end
    end
    highest_scoring_home_team.team_name
  end

  def lowest_scoring_visitor
    lowest_scoring_away_team = teams.min_by do |team|
      if team.games_played_as_visitor(games) != 0
        team.total_away_points(games).to_f / team.games_played_as_visitor(games)
      else
        100
      end
    end
    lowest_scoring_away_team.team_name
  end

  def lowest_scoring_home_team
    lowest_scoring_home_team = teams.min_by do |team|
      if team.games_played_as_home_team(games) != 0
        team.total_home_points(games).to_f / team.games_played_as_home_team(games)
      else
        100
      end
    end
    lowest_scoring_home_team.team_name
  end




end
