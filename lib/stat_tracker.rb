require 'csv'
require_relative 'game'
require_relative 'team'
require 'pry'
require_relative 'game_team'
require_relative 'team_stats'
require_relative 'game_stats'
require_relative 'game_team_stats'
require_relative 'season_stats'
require_relative 'venue_stats'

class StatTracker
  include TeamStats, GameStats, GameTeamStats, SeasonStats, VenueStats

  attr_accessor :teams,
                :games,
                :game_teams

  attr_reader :team_stats

  def initialize(info_hash)
    @games = []
    game_instance(info_hash[:games])
    @teams = []
    team_instance(info_hash[:teams])
    assign_percentages_to_teams
    @game_teams = []
    game_team_instance(info_hash[:game_teams])
  end

  def self.from_csv(data) ###### maybe load the csvs to local variables??
    StatTracker.new(data)
  end

 ####################### Instance Creation###########################

  def game_instance(game_file)
    CSV.foreach(game_file, headers: true, header_converters: :symbol) do |row|
      @games << Game.new(row)
    end
  end

  def team_instance(team_file)
    CSV.foreach(team_file, headers: true, header_converters: :symbol) do |row|
      team = Team.new(row)
      @teams << team
    end
  end

#not sure what this method is for:

  # def games_by_team_instance(team)
  #   team.team_id
  # end

  def game_team_instance(game_team_file)
    CSV.foreach(game_team_file, headers: true, header_converters: :symbol) do |row|
      @game_teams << GameTeam.new(row)
    end
  end
########### HELPER METHOD FOR THE VENUE METHODS

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

  def winningest_team
    team_with_highest_win_percentage = @teams.max_by do |team|
      team.number_of_games_won(games).to_f / team.games_played_in(games).count
    end
    team_with_highest_win_percentage.team_name
  end


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

  def best_fans
    best_fans_team = @teams.max_by do |team|
      team.home_win_percentage - team.away_win_percentage
    end
    best_fans_team.team_name
  end

  def worst_fans
    worst_fans_teams = @teams.select do |team|
      team.away_win_percentage > team.home_win_percentage
    end

    worst_fans_teams.map do |team|
      team.team_name
    end
  end

  def count_of_teams
    @teams.count
  end

  def games_by_all_team_ids
    @game_teams.group_by do |game_team|
      game_team.team_id
    end
  end

  def games_by_team_id(team_id) #returns game_team_instance
    games_by_all_team_ids[team_id]
  end

  def team_total_score(team_id)
    games_by_team_id(team_id).sum do |game|
      game.goals.to_i
    end
  end

  def game_count_by_team_id(team_id)
    games_by_team_id(team_id).count
  end

  def average_score_by_team_id(team_id)
    team_total_score(team_id).to_f / game_count_by_team_id(team_id).to_f
  end

  def best_offense_by_team_name
    best_team = @teams.max_by do |team|
      average_score_by_team_id(team.team_id)
    end
    return best_team.team_name
  end

  def worst_offense_by_team_name
    worst_team = @teams.min_by do |team|
      average_score_by_team_id(team.team_id)
    end
    return worst_team.team_name
  end

  def get_opponent_team_game_ids(team_id)
    games_by_team_id(team_id).map do |g_t|
      g_t.game_id
    end
  end

  def get_opponent_game_teams(team_id)
    get_opponent_team_game_ids(team_id).map do |game_id|
      game_teams.find do |g_t|
        g_t.game_id == game_id && g_t.team_id != team_id
      end
    end
  end

  def team_opponent_goals(team_id)
    get_opponent_game_teams(team_id).sum do |g_t|
      g_t.goals.to_i
    end
  end

  def all_teams_opponent_averages
    all_teams = {}

    @teams.each do |team|
      all_teams[team.team_id] = (team_opponent_goals(team.team_id))/game_count_by_team_id(team.team_id).to_f
    end

    all_teams
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

  def best_defense
    team_id = all_teams_opponent_averages.key(all_teams_opponent_averages.values.min)
    get_team_name_from_id(team_id)
  end

  def worst_defense
    team_id = all_teams_opponent_averages.key(all_teams_opponent_averages.values.max)
    get_team_name_from_id(team_id)
  end


  def get_opponent_goals(team_id, games = @games)
    goals = 0
    games.each do |game|
      if game.away_team_id == team_id
        goals += game.home_goals
      elsif game.home_team_id == team_id
        goals += game.away_goals
      end
    end
    goals

  end


end
