require 'csv'
require_relative 'game'
require_relative 'team'
require 'pry'

class StatTracker
  attr_accessor :teams,
                :games

  def initialize(info_hash)
    @games = []
    game_instance(info_hash[:games])
    @teams = []
    team_instance(info_hash[:teams])

  end

  def self.from_csv(data)
    StatTracker.new(data)
  end

  def game_instance(game_file)
    CSV.foreach(game_file, headers: true, header_converters: :symbol) do |row|
      @games << Game.new(row)
    end
  end

  def highest_total_score
    max_game = @games.max_by do |game|
      game.total_score
    end
    max_game.total_score
  end

  def team_instance(team_file)
    CSV.foreach(team_file, headers: true, header_converters: :symbol) do |row|
      @teams << Team.new(row)
    end
  end

  def percentage_home_wins
    games_won_by_home = games.find_all do |game|
      game.outcome[0..3] == "home"
    end
    (games_won_by_home.count.to_f / games.count * 100).round(2)
  end

  def team_info(id)
    found_team = @teams.find do |team|
      team.team_id == id
    end
    team_hash = Hash.new
    team_hash[id] = found_team.provide_info
  end

  def average_goals_per_game
    total_goals = @games.inject(0) do |sum, game|
      sum + game.total_score
    end
    (total_goals.to_f/@games.length.to_f).round(2)
  end

  def games_by_season
    @games.group_by do |game|
      game.season
    end
  end

  def average_goals_by_season
    average_by_season = {}
    games_by_season.each do |season, games|
      total_score_for_season = games.inject(0) do |sum, game|
        sum + game.total_score
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

  def game_count_by_venue
    venue_events = @games.group_by do |game|
      game.venue
    end
    venue_events.map do |venue, games|
      [venue, games.count]
    end
  end

  def most_popular_venue
    most_popular = game_count_by_venue.max_by do |venue_count|
      venue_count.last
    end
    return most_popular.first
  end

  def least_popular_venue
    least_popular = game_count_by_venue.min_by do |venue_count|
      venue_count.last
    end
    return least_popular.first
  end

  def count_of_games_by_season
    game_count_by_season = {}
    games_by_season.each do |season, games|
      game_count_by_season[season] = games.count
    end
    return game_count_by_season
  end

  def season_with_most_games
    highest_count = count_of_games_by_season.values.max
    count_of_games_by_season.key(highest_count).to_i
  end

  def season_with_fewest_games
    lowest_count = count_of_games_by_season.values.min
    count_of_games_by_season.key(lowest_count).to_i
  end

  def percentage_visitor_wins
    games_won_by_visitor = games.find_all do |game|
      game.outcome[0..3] == "away"
    end
    (games_won_by_visitor.count.to_f / games.count * 100).round(2)
  end

  def lowest_scoring_visitor
    lowest_scoring_away_team = teams.min_by do |team|
      total_away_points = games.sum do |game|
        if team.team_id == game.away_team_id
          game.away_goals
        else
          0
        end
      end
      games_played_as_visitor = games.count do |game|
        game.away_team_id == team.team_id
      end
      if games_played_as_visitor != 0
        total_away_points.to_f / games_played_as_visitor
      else
        100
      end
    end
    lowest_scoring_away_team.team_name
  end

  def lowest_scoring_home_team
    lowest_scoring_home_team = teams.min_by do |team|
      total_home_points = games.sum do |game|
        if team.team_id == game.home_team_id
          game.home_goals
        else
          0
        end
      end
      games_played_as_home_team = games.count do |game|
        game.home_team_id == team.team_id
      end
      if games_played_as_home_team != 0
        total_home_points.to_f / games_played_as_home_team
      else
        100
      end
    end
    lowest_scoring_home_team.team_name
  end

  def highest_scoring_home_team
    highest_scoring_home_team = teams.max_by do |team|
      total_home_points = games.sum do |game|
        if team.team_id == game.home_team_id
          game.home_goals
        else
          0
        end
      end
      games_played_as_home_team = games.count do |game|
        game.home_team_id == team.team_id
      end
      if games_played_as_home_team != 0
        total_home_points.to_f / games_played_as_home_team
      else
        0
      end
    end
    highest_scoring_home_team.team_name
  end

  def highest_scoring_visitor
    highest_scoring_away_team = teams.max_by do |team|
      total_away_points = games.sum do |game|
        if team.team_id == game.away_team_id
          game.away_goals
        else
          0
        end
      end
      games_played_as_visitor = games.count do |game|
        game.away_team_id == team.team_id
      end
      if games_played_as_visitor != 0
        total_away_points.to_f / games_played_as_visitor
      else
        0
      end
    end
    highest_scoring_away_team.team_name
  end

  def winningest_team
    team_with_highest_win_percentage = @teams.max_by do |team|
      total_wins = @games.inject(0) do |wins, game|
        if team.team_id == game.away_team_id && game.outcome.include?("away")
          wins + 1
        elsif team.team_id == game.home_team_id && game.outcome.include?("home")
          wins + 1
        else
          wins
        end
      end
      total_games_played = @games.inject(0) do |total_played, game|
        if team.team_id == game.away_team_id || team.team_id == game.home_team_id
          total_played + 1
        else
          total_played
        end
      end
      total_wins.to_f / total_games_played
    end
    team_with_highest_win_percentage.team_name
  end

  def biggest_bust(season_id)
    preseason = []
    reg_season = []
    @games.each do |game|
      if season_id == game.season && game.type == "P"
        preseason << game
      elsif season_id == game.season && game.type == "R"
        reg_season << game
      end
    end
    largest_decrease_in_percentage = @teams.max_by do |team|
      total_preseason_wins = preseason.inject(0) do |wins, game|
        if team.team_id == game.away_team_id && game.outcome.include?("away")
          wins + 1
        elsif team.team_id == game.home_team_id && game.outcome.include?("home")
          wins + 1
        else
          wins
        end
      end
      total_preseason_games_played = preseason.inject(0) do |total_played, game|
        if team.team_id == game.away_team_id || team.team_id == game.home_team_id
          total_played + 1
        else
          total_played
        end
      end
      preseason_win_percentage = total_preseason_wins.to_f / total_preseason_games_played
      total_reg_season_wins = reg_season.inject(0) do |wins, game|
        if team.team_id == game.away_team_id && game.outcome.include?("away")
          wins + 1
        elsif team.team_id == game.home_team_id && game.outcome.include?("home")
          wins + 1
        else
          wins
        end
      end
      total_reg_season_games_played = reg_season.inject(0) do |total_played, game|
        if team.team_id == game.away_team_id || team.team_id == game.home_team_id
          total_played + 1
        else
          total_played
        end
      end
      reg_season_win_percentage = total_reg_season_wins.to_f / total_reg_season_games_played
      if reg_season_win_percentage != 0
        preseason_win_percentage/reg_season_win_percentage
      else
        100
      end
    end
    largest_decrease_in_percentage.team_name
  end
end
