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
    total = seasons_by_win_percentage(team_id).values.sum
    count = seasons_by_win_percentage(team_id).count
    total / count
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
    lowest_win_percentage = opponents_by_win_percentage(team_id).values.min
    opponent_id = opponents_by_win_percentage(team_id).key(lowest_win_percentage)
    get_team_name_from_id(opponent_id)
  end

  def rival(team_id)
    highest_win_percentage = opponents_by_win_percentage(team_id).values.max
    opponent_id = opponents_by_win_percentage(team_id).key(highest_win_percentage)
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

  def head_to_head(team_id, opponent_team_id)
    game_teams = game_teams_by_team_id(team_id)
    opponent_game_teams = game_teams_by_team_id(opponent_team_id)
    wins = 0
    losses = 0

    if game_teams && opponent_game_teams
      game_teams.each do |g_t|
        opponent_game_teams.each do |opp_g_t|

          if g_t.game_id == opp_g_t.game_id
            if g_t.won == "TRUE"
              wins += 1
            else
              losses += 1
            end
          end

        end
      end
    end
    {win: wins, loss: losses}
  end

end
