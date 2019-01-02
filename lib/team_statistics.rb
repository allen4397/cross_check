module TeamStatistics

  def team_info(id)
    team_hash = Hash.new
    team_hash[id] = find_team(id).provide_info
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
    find_team(team_id).win_percentage(@games)
  end

  def most_goals_scored(team_id)
    max_goals = game_teams_by_team_id(team_id).max_by do |game_team|
      game_team.goals
    end
    return max_goals.goals.to_i
  end

  def fewest_goals_scored(team_id) #this uses game_teams, not games
    min_goals = game_teams_by_team_id(team_id).min_by do |game_team|
      game_team.goals
    end
    return min_goals.goals.to_i
  end

  def favorite_opponent(team_id)
    opponents_hash = opponents_by_win_percentage(team_id)
    lowest_win_percentage = opponents_hash.values.min
    opponent_id = opponents_hash.key(lowest_win_percentage)
    get_team_name_from_id(opponent_id)
  end

  def rival(team_id)
    opponents_hash = opponents_by_win_percentage(team_id)
    highest_win_percentage = opponents_hash.values.max
    opponent_id = opponents_hash.key(highest_win_percentage)
    get_team_name_from_id(opponent_id)
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

  def get_all_opponents(team_id)
  end

  def head_to_head(team_id)
    head_to_head = Hash.new
    query_team = find_team(team_id)

    @teams.each do |team|
      if team.team_id != query_team.team_id
        games_played_against_query_team = query_team.opponent_games(team.team_id, @games)
        head_to_head[team.team_name] = query_team.win_percentage(games_played_against_query_team)
      end
    end 
    head_to_head
  end


end
