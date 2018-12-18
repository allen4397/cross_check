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


end
