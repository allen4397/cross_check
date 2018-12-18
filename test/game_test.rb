require './test/test_helper'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/game'
require './lib/stat_tracker'

class GameTest < Minitest::Test

  def setup
    game_path = './data/test_game.csv'
    team_path = './data/team_info.csv'
    game_teams_path = './data/game_teams_stats.csv'

    @locations = {
     games: game_path,
     teams: team_path,
     game_teams: game_teams_path
    }

    @stat_tracker = StatTracker.new(@locations)
  end

  def test_it_exists
    game = @stat_tracker.games[0]

    assert_instance_of Game, game
  end

  def test_it_can_calculate_total_score
    game = @stat_tracker.games[0]

    assert_equal 5, game.total_score
  end

  def test_it_can_report_the_outcome
    game = @stat_tracker.games[0]

    assert_equal "home win OT", game.outcome
  end

  def test_it_calculates_score_difference
    game = @stat_tracker.games[0]

    assert_equal 1, game.score_difference
  end 

end
