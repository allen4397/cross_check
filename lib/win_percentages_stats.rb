module WinPercentagesStats

  def home_win_percentages(team_id, games)
    games_played_at_home = games.select do |game|
      game.home_team_id == team_id
    end

    games_won_at_home =  games_played_at_home.count do |game|
      game.outcome.include?("home")
    end
    if games_played_at_home.length != 0
      return (games_won_at_home.to_f / games_played_at_home.length) * 100.0
    else
      return 0.0
    end
  end

  def away_win_percentages(team_id, games)
    games_played_away = games.select do |game|
      game.away_team_id == team_id
    end

    games_won_away =  games_played_away.count do |game|
      game.outcome.include?("away")
    end

    if games_played_away.length != 0
      return (games_won_away.to_f / games_played_away.length) * 100.0
    else
      return 0.0
    end
  end


  def home_win_percentage_per_team
    home_win_percentage = Hash.new(0)

    games_played_at_home_per_team = @games.group_by do |game|
      game.home_team_id
    end

    games_played_at_home_per_team.each do |home_team_id, games|
      home_win_percentage[home_team_id] = home_win_percentages(home_team_id, games)
    end
    home_win_percentage

  end

  def away_win_percentage_per_team
    away_win_percentage = Hash.new(0)
    games_played_away_per_team = @games.group_by do |game|
      game.away_team_id
    end

    games_played_away_per_team.each do |away_team_id, games|
      away_win_percentage[away_team_id] = away_win_percentages(away_team_id,games)
    end
    away_win_percentage
  end

  def assign_percentages_to_teams
    @teams.each do |team|
      team.away_win_percentage = away_win_percentage_per_team[team.team_id]
    end

    @teams.each do |team|
      team.home_win_percentage = home_win_percentage_per_team[team.team_id]
    end
  end

  def percentage_home_wins
    games_won_by_home = games.find_all do |game|
      game.outcome[0..3] == "home"
    end
    (games_won_by_home.count.to_f / games.count * 100).round(2)
  end

  def percentage_visitor_wins
    games_won_by_visitor = games.find_all do |game|
      game.outcome[0..3] == "away"
    end
    (games_won_by_visitor.count.to_f / games.count * 100).round(2)
  end

end
