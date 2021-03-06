require_relative 'game'

class Team

  attr_reader :team_id,
              :team_name

  attr_accessor :away_win_percentage,
                :home_win_percentage

  def initialize(team_info)
    @team_id = team_info[:team_id]
    @franchise_id = team_info[:franchiseid]
    @short_name = team_info[:shortname]
    @team_name = team_info[:teamname]
    @abbreviation = team_info[:abbreviation]
    @link = team_info[:link]
    @away_win_percentage = 0
    @home_win_percentage = 0
  end

  def provide_info
                { "franchise_id" => @franchise_id,
                  "short_name" => @short_name,
                  "team_name" => @team_name,
                  "abbreviation" => @abbreviation,
                  "link" => @link,
                  "team_id" => @team_id}
  end

  def win_percentage(games)
    if games_played_in(games).count != 0
      (number_of_games_won(games)/games_played_in(games).count.to_f).round(2)
    else
      0
    end
  end

  def games_won(games)
    games.find_all do |game|
      game.away_team_id == @team_id && game.outcome.include?("away") || game.home_team_id == @team_id && game.outcome.include?("home")
    end
  end

  def games_lost(games)
    games.find_all do |game|
      game.away_team_id == @team_id && game.outcome.include?("home") || game.home_team_id == @team_id && game.outcome.include?("away")
    end
  end

  def number_of_games_won(games)
    games_won(games).count
  end

  def games_played_in(games)
    games.find_all do |game|
      game.away_team_id == @team_id || game.home_team_id == @team_id
    end
  end

  def total_away_points(games)
    games.sum do |game|
      if team_id == game.away_team_id
        game.away_goals
      else
        0
      end
    end
  end

  def total_home_points(games)
    games.sum do |game|
      if team_id == game.home_team_id
        game.home_goals
      else
        0
      end
    end
  end

  def goals_scored(games)
    total_home_points(games) + total_away_points(games)
  end

  def goals_against(games)
    games.sum do |game|
      if team_id == game.home_team_id
        game.away_goals
      elsif team_id == game.away_team_id
        game.home_goals
      else
        0
      end
    end
  end

  def games_played_as_visitor(games)
    games.count do |game|
      game.away_team_id == team_id
    end
  end

  def games_played_as_home_team(games)
    games.count do |game|
      game.home_team_id == team_id
    end
  end

  def average_goals_scored(games)
    if games_played_in(games).count != 0
      ((goals_scored(games)).to_f / games_played_in(games).count).round(2)
    else
      0.0
    end

  end

  def average_goals_against(games)
    if games_played_in(games).count != 0
      (goals_against(games).to_f / games_played_in(games).count).round(2)
    else
      0.0
    end
  end

  def opponent_games(opponent_id, games)
    games_played_in(games).select do |game|
      game.away_team_id == opponent_id || game.home_team_id == opponent_id
    end
  end


end
