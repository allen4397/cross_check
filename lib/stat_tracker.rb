require 'csv'
require_relative 'game'

class StatTracker
  attr_reader :games

  def initialize(info_hash)
    @games = []
    game_instance(info_hash[:games])
  end

  def self.from_csv(data)
    StatTracker.new(data)
  end

  def game_instance(game_file)
    CSV.foreach(game_file, headers: true, header_converters: :symbol) do |row|
      @games << Game.new(row)
    end
  end
end
