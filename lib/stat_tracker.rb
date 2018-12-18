require 'csv'
require_relative 'game'
require_relative 'team'

class StatTracker
  attr_reader :games,
              :teams

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
    venue_count = venue_events.map do |venue, games|
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
    games_by_season = @games.group_by do |game|
      game.season
    end
    games_by_season.each do |season, games|
      game_count_by_season[season] = games.count
    end
    return game_count_by_season
  end

  def season_with_most_games
    highest_count = count_of_games_by_season.values.max
    count_of_games_by_season.key(highest_count)
  end

  def season_with_fewest_games
    lowest_count = count_of_games_by_season.values.min
    count_of_games_by_season.key(lowest_count)
  end

end
