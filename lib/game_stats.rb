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

  def average_goals_per_game
    total_goals = @games.sum do |game|
      game.total_score
    end
    (total_goals.to_f/@games.length.to_f).round(2)
  end

  def all_games_by_season
    @games.group_by do |game|
      game.season
    end
  end

end
