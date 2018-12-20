require './test/test_helper'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/game_team'
require './lib/stat_tracker'
require 'pry'

class GameTeamTest < Minitest::Test

  def setup
    game_path = './data/test_game.csv'
    team_path = './data/test_team.csv'
    game_teams_path = './data/game_teams_stats.csv'

    @locations = {
     games: game_path,
     teams: team_path,
     game_teams: game_teams_path
    }
    @stat_tracker = StatTracker.from_csv(@locations)
  end

  def test_it_exists
    assert_instance_of GameTeam, @stat_tracker.game_teams[0]
  end 

  def test_it_gets_missed_shots
    assert_equal 33, @stat_tracker.game_teams[0].missed_shots
  end

end
