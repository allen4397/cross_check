module GameStats

  def game_stats_module_works
    "Game stats module works!"
  end


  def highest_total_score
    max_game = @games.max_by do |game|
      game.total_score
    end
    max_game.total_score
  end

  def percentage_home_wins
    games_won_by_home = games.find_all do |game|
      game.outcome[0..3] == "home"
    end
    (games_won_by_home.count.to_f / games.count * 100).round(2)
  end

  def average_goals_per_game
    total_goals = @games.sum do |game|
      game.total_score
    end
    (total_goals.to_f/@games.length.to_f).round(2)
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

  def lowest_total_score
    min_game = @games.min_by do |game|
      game.total_score
    end
    min_game.total_score
  end

  def biggest_blowout
    blowout_game = @games.max_by do |game|
      game.score_difference
    end
    blowout_game.score_difference
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

  def all_games_by_season
    @games.group_by do |game|
      game.season
    end
  end

end
