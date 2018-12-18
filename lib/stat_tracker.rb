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

  def average_goals_by_season
    hash = @games.group_by do |game|
      game.season
    end
    hash.each do |k, v|
      games_scores = v.inject(0) do |sum, games|
        sum + games.total_score
      end
      hash[k] = (games_scores.to_f/hash.values.flatten.length.to_f).round(2)
    end

  end


end
