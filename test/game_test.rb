require './test/test_helper'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/game'

class GameTest < Minitest::Test
  def test_it_exists
    game = Game.new

    assert_instance_of Game, game
  end
end
