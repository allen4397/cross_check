require './test/test_helper'
require 'minitest/autorun'
require 'minitest/pride'
require 'mocha/minitest'
require './lib/stat_tracker'
require './lib/teams_info'
require './lib/team_statistics'
require 'pry'

class StatTrackerTeamTest < Minitest::Test

  def setup
    game_path = './data/test_game.csv'
    team_path = './data/test_team.csv'
    game_teams_path = './data/test_game_team_stats.csv'

    @locations = {
     games: game_path,
     teams: team_path,
     game_teams: game_teams_path
    }

    @stat_tracker = StatTracker.from_csv(@locations)
  end

  def test_it_gets_team_info
    expected = {franchise_id: "10",
                short_name: "NY Rangers",
                team_name: "Rangers",
                abbreviation: "NYR",
                link: "/api/v1/teams/3"}
    assert_equal expected, @stat_tracker.team_info("3")
  end

  def test_it_gets_seasons_by_team

    expected = ["20122013", "20132014"]
    assert_equal expected, @stat_tracker.seasons_by_team("6")
  end

  def test_it_gets_games_by_team_id

    game = @stat_tracker.games
    expected = [game[0], game[1], game[2], game[3], game[4]]
    assert_equal expected, @stat_tracker.find_games_by_team_id("3")
  end

  def test_it_gets_game_teams_by_team_id
    gt = @stat_tracker.game_teams
    t3games = [gt[0], gt[2], gt[5], gt[7], gt[8]]
    expected = t3games
    assert_equal expected, @stat_tracker.game_teams_by_team_id("3")
  end

  def test_it_gets_games_by_season_for_team_id

    game = @stat_tracker.games
    expected = [game[10]]
    assert_equal expected, @stat_tracker.games_by_team_by_season("20132014", "6")
  end

  def test_it_gets_seasons_by_win_percentage_for_team

    expected = {"20122013" => 80.0, "20132014" => 100.0}
    assert_equal expected, @stat_tracker.seasons_by_win_percentage("6")
  end

  def test_it_gets_best_season
    assert_equal "20132014", @stat_tracker.best_season("6")
  end

  def test_it_gets_worst_season
    assert_equal "20122013", @stat_tracker.worst_season("6")
  end

  def test_it_averages_all_season_win_percentages_for_team

    assert_equal 90.0, @stat_tracker.average_win_percentage("6")
  end

  def test_it_gets_highest_goals_for_team
    assert_equal 5, @stat_tracker.most_goals_scored("6")
  end

  def test_it_gets_fewest_goals_for_team
    assert_equal 2, @stat_tracker.fewest_goals_scored("6")
  end

  def test_it_can_calculate_biggest_team_blowout
    assert_equal 3, @stat_tracker.biggest_team_blowout("6")
  end

  def test_it_can_calculate_worst_loss
    assert_equal 1, @stat_tracker.worst_loss("6")
  end

  def test_it_gets_opponent_team_ids
    assert_equal ["3", "17"], @stat_tracker.opponent_team_ids("6")
  end

  def test_it_gets_opponents_by_win_percentage
    expected = {"3"=>20.00, "17"=>50.00}
    assert_equal expected, @stat_tracker.opponents_by_win_percentage("6")
  end

  def test_it_gets_opponent_with_lowest_win_percentage
    assert_equal "Rangers", @stat_tracker.favorite_opponent("6")
  end

  def test_it_gets_opponent_with_highest_win_percentage
    assert_equal "Red Wings", @stat_tracker.rival("6")
  end
end
