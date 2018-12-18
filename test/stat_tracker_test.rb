require './test/test_helper'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/stat_tracker'

class StatTrackerTest < Minitest::Test

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

    assert_instance_of StatTracker, @stat_tracker
  end

  def test_it_creates_games_off_csv

    assert_instance_of Game, @stat_tracker.games[0]
    assert_equal 8, @stat_tracker.games.count
  end

  def test_it_can_calculate_highest_total_score

    assert_equal 7, @stat_tracker.highest_total_score

  end

  def test_it_creates_teams_off_csv
    assert_instance_of Team, @stat_tracker.teams[0]
    assert_equal 4, @stat_tracker.teams.count
  end

  def test_it_can_calculate_percentage_of_games_won_by_home_team
    assert_equal 50.0, @stat_tracker.percentage_home_wins
  end

  def test_it_can_calculate_percentage_of_games_won_by_away_team
    assert_equal 50.0, @stat_tracker.percentage_visitor_wins
  end
end
