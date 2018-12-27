require './test/test_helper'
require 'minitest/autorun'
require 'minitest/pride'
require 'mocha/minitest'
require './lib/game'
require './lib/stat_tracker'
require 'pry'

class TeamTest < Minitest::Test

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

    assert_instance_of Team, @stat_tracker.teams[0]
  end

  def test_it_can_provide_info
    expected = {
                franchise_id: "6",
                short_name: "Boston",
                team_name: "Bruins",
                abbreviation: "BOS",
                link: "/api/v1/teams/6"
    }

    test_team = @stat_tracker.teams[0]

    assert_equal expected, test_team.provide_info

  end

  def test_it_can_return_games_won
    game_1 = @stat_tracker.games[0]
    game_2 = @stat_tracker.games[1]
    game_3 = @stat_tracker.games[2]
    game_4 = @stat_tracker.games[4]
    game_5 = @stat_tracker.games[10]

    assert_equal [game_1, game_2, game_3, game_4, game_5], @stat_tracker.teams[0].games_won(@stat_tracker.games)
  end

  def test_it_can_return_games_lost
    game_1 = @stat_tracker.games[3]

    assert_equal [game_1], @stat_tracker.teams[0].games_lost(@stat_tracker.games)
  end

  def test_it_can_calculate_win_percentage
    team = @stat_tracker.teams[0]
    assert_equal 83.33 , team.win_percentage(@stat_tracker.games)
  end

  def test_it_can_calculate_total_away_points
    team = @stat_tracker.teams[0]
    game_1 = mock
    game_2 = mock
    game_3 = mock
    @stat_tracker.games = [game_1, game_2, game_3]

    game_1.stubs(:away_team_id).returns("3")
    game_2.stubs(:away_team_id).returns("6")
    game_3.stubs(:away_team_id).returns("6")

    game_1.stubs(:away_goals).returns(3)
    game_2.stubs(:away_goals).returns(5)
    game_3.stubs(:away_goals).returns(2)

    assert_equal 7, team.total_away_points(@stat_tracker.games)
  end

  def test_it_can_calculate_total_home_points
    team = @stat_tracker.teams[0]
    game_1 = mock
    game_2 = mock
    game_3 = mock
    @stat_tracker.games = [game_1, game_2, game_3]

    game_1.stubs(:home_team_id).returns("6")
    game_2.stubs(:home_team_id).returns("3")
    game_3.stubs(:home_team_id).returns("6")

    game_1.stubs(:home_goals).returns(4)
    game_2.stubs(:home_goals).returns(3)
    game_3.stubs(:home_goals).returns(1)

    assert_equal 5, team.total_home_points(@stat_tracker.games)
  end

  def test_it_can_calculate_number_of_games_played_as_visitor
    team = @stat_tracker.teams[0]
    game_1 = mock
    game_2 = mock
    game_3 = mock
    @stat_tracker.games = [game_1, game_2, game_3]

    game_1.stubs(:away_team_id).returns("3")
    game_2.stubs(:away_team_id).returns("6")
    game_3.stubs(:away_team_id).returns("6")

    assert_equal 2, team.games_played_as_visitor(@stat_tracker.games)
  end

  def test_it_can_calculate_number_of_games_played_as_home_team
    team = @stat_tracker.teams[0]
    game_1 = mock
    game_2 = mock
    game_3 = mock
    @stat_tracker.games = [game_1, game_2, game_3]

    game_1.stubs(:home_team_id).returns("3")
    game_2.stubs(:home_team_id).returns("3")
    game_3.stubs(:home_team_id).returns("6")

    assert_equal 1, team.games_played_as_home_team(@stat_tracker.games)
  end
end
