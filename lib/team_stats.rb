module TeamStats

  def test_module
    "THIS MODULE WORKS!"
  end

  def find_team(team_id)
    @teams.find do |team|
      team.team_id == team_id
    end
  end

  def get_team_name_from_id(team_id)
    team_name = nil

    @teams.each do |team|
      if team.team_id == team_id
        team_name = team.team_name
      end
    end

    team_name
  end

  def seasons_by_team(team_id)
    find_games_by_team_id(team_id).map do |game|
      game.season
    end.uniq
  end

  def find_games_by_team_id(team_id, games = @games)
    games.select do |game|
      game.away_team_id == team_id || game.home_team_id == team_id
    end
  end

  def games_by_team_by_season(season, team_id)
    find_games_by_team_id(team_id, all_games_by_season[season])
  end

  def opponent_team_ids(team_id)
    opponent_game_teams(team_id).map do |gt|
      gt.team_id
    end.uniq
  end

  def opponents_by_win_percentage(team_id)
    opp_win_perc = {}
    opponent_team_ids(team_id).each do |opponent_id|
      opp_win_perc[opponent_id] = find_team(opponent_id).win_percentage(@games)
    end
    opp_win_perc
  end


end
