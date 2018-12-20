require 'csv'
require_relative 'game'
require_relative 'team'


class StatTracker
  attr_reader :games

  attr_accessor :teams

  def initialize(info_hash)
    @games = []
    game_instance(info_hash[:games])
    @teams = []
    team_instance(info_hash[:teams])
    assign_percentages_to_teams
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


  def home_win_percentages(team_id, games)
    games_won_at_home =  games.count do |game|
      game.home_team_id == team_id && game.outcome.include?("home")
    end
    if games.length != 0
      return (games_won_at_home.to_f / games.length) * 100.0
    else
      return 0.0
    end
  end

  def away_win_percentages(team_id, games)
    games_won_away =  games.count do |game|
      game.away_team_id == team_id && game.outcome.include?("away")
    end
    if games.length != 0
      return (games_won_away.to_f / games.length) * 100.0
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

  # def games_by_teams_location(home_or_away)
  #
  #   @teams.each do |team|
  #     if
  #   games_by_location = @games.group_by do |game|
  #     if team_id == game.away_team_id
  #       game.away_team_id
  #     elsif team_id == game.home_team_id
  #       game.home_team_id
  #     end
  #     games_by_location
  # end
  #
  # end

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


def games_by_season_type(season_id, team_id)

  games_by_type_of_season = Hash.new
  games_in_season = games_by_season[season_id]

  preseason = games_in_season.select do |game|
    game.type == "P"
  end

  regular_season = games_in_season.select do |game|
    game.type == "R"
  end

  games_by_type_of_season[:preseason] = preseason
  games_by_type_of_season[:regular_season] = regular_season

  games_by_type_of_season[:preseason].delete_if do |game|
    game.away_team_id != team_id && game.home_team_id != team_id
  end

  games_by_type_of_season[:regular_season].delete_if do |game|
    game.away_team_id != team_id && game.home_team_id != team_id
  end

  games_by_type_of_season

end

def win_percentage(team_id,games)
  away_win_percentages(team_id, games) + home_win_percentages(team_id, games)
end

def season_summary(season_id, team_id)
  summary = {}
  by_season_type_for_given_team = games_by_season_type(season_id, team_id)
  preseason_stats = {}

  preseason_wins = win_percentage(team_id,by_season_type_for_given_team[:preseason])

  regular_wins = win_percentage(team_id, by_season_type_for_given_team[:regular_season])

  preseason_goals = by_season_type_for_given_team[:preseason].sum{|game| game.total_score}


  summary[:preseason]


end





end
