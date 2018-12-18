require './test/test_helper'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/stat_tracker'
require 'pry'

class StatTrackerTest < Minitest::Test

  def setup
    game_path = './data/test_game.csv'
    team_path = './data/test_team.csv'
    game_teams_path = './data/test_game_teams_stats.csv'

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
    skip
    assert_instance_of Game, @stat_tracker.games[0]
    assert_equal 6, @stat_tracker.games.count
  end

  def test_it_can_calculate_highest_total_score

    assert_equal 7, @stat_tracker.highest_total_score
  end

  def test_it_creates_teams_off_csv
    skip
    assert_instance_of Team, @stat_tracker.teams[0]
    assert_equal 6, @stat_tracker.teams.count
  end

  def test_it_provides_team_info_from_team_id
    expected = {
                franchise_id: "23",
                short_name: "New Jersey",
                team_name: "Devils",
                abbreviation: "NJD",
                link: "/api/v1/teams/1"
    }


    assert_equal expected, @stat_tracker.team_info("1")

  end

  def test_it_can_calculate_average_goals_per_game

    assert_equal 4.83, @stat_tracker.average_goals_per_game
  end

  def test_it_can_calculate_average_goals_by_season

    expected = {"20122013" => 4.83}

    assert_equal expected, @stat_tracker.average_goals_by_season
  end

  def test_it_calculates_lowest_total_score
    assert_equal 3, @stat_tracker.lowest_total_score
  end

  def test_it_finds_biggest_blowout
    assert_equal 3, @stat_tracker.biggest_blowout
  end

  def test_it_gets_game_count_by_venue
    skip
    expected = [["TD Garden", 3], ["Madison Square Garden", 2], ["CONSOL Energy Center", 1]]

    assert_equal expected, @stat_tracker.game_count_by_venue
  end

  def test_it_gets_venue_with_most_games
    skip
    assert_equal "TD Garden", @stat_tracker.most_popular_venue
  end

  def test_it_gets_venue_with_fewest_games
    skip
    assert_equal "CONSOL Energy Center", @stat_tracker.least_popular_venue
  end

  def test_it_gets_game_count_by_season
    expected = { "20122013" => 6, "20132014" => 1}

    assert_equal expected, @stat_tracker.count_of_games_by_season
  end

  def test_it_gets_busiest_season
    assert_equal "20122013", @stat_tracker.season_with_most_games
  end

  def test_it_gets_least_busy_season
    assert_equal "20132014", @stat_tracker.season_with_fewest_games
  end

end
