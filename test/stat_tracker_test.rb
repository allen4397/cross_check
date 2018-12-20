require './test/test_helper'
require 'minitest/autorun'
require 'minitest/pride'
require 'mocha/minitest'
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
    assert_instance_of Game, @stat_tracker.games[0]
    assert_equal 10, @stat_tracker.games.count
  end

  def test_it_can_calculate_highest_total_score
    assert_equal 7, @stat_tracker.highest_total_score
  end

  def test_it_creates_teams_off_csv
    assert_instance_of Team, @stat_tracker.teams[0]
    assert_equal 6, @stat_tracker.teams.count
  end

  def test_it_can_calculate_percentage_of_games_won_by_home_team
    assert_equal 50.0, @stat_tracker.percentage_home_wins
  end

  def test_it_can_calculate_percentage_of_games_won_by_away_team
    assert_equal 50.0, @stat_tracker.percentage_visitor_wins
  end

  def test_it_provides_team_info_from_team_id
    expected = {
                franchise_id: "10",
                short_name: "NY Rangers",
                team_name: "Rangers",
                abbreviation: "NYR",
                link: "/api/v1/teams/3"
    }


    assert_equal expected, @stat_tracker.team_info("3")
  end

  def test_it_can_calculate_average_goals_per_game
    assert_equal 4.9, @stat_tracker.average_goals_per_game
  end

  def test_it_can_calculate_average_goals_by_season
    expected = {"20122013" => 5.17, "20152016" => 4.5}
    assert_equal expected, @stat_tracker.average_goals_by_season
  end

  def test_it_calculates_lowest_total_score
    assert_equal 1, @stat_tracker.lowest_total_score
  end

  def test_it_finds_biggest_blowout
    assert_equal 3, @stat_tracker.biggest_blowout
  end

  def test_it_gets_game_count_by_venue
    expected = [["TD Garden", 3], ["Madison Square Garden", 2], ["Honda Center", 1], ["Scottrade Center", 2], ["United Center", 2]]

    assert_equal expected, @stat_tracker.game_count_by_venue
  end

  def test_it_gets_venue_with_most_games
    assert_equal "TD Garden", @stat_tracker.most_popular_venue
  end

  def test_it_gets_venue_with_fewest_games
    assert_equal "Honda Center", @stat_tracker.least_popular_venue
  end

  def test_it_gets_game_count_by_season
    expected = {"20122013" => 6, "20152016" => 4}

    assert_equal expected, @stat_tracker.count_of_games_by_season
  end

  def test_it_gets_season_with_most_games
    assert_equal 20122013, @stat_tracker.season_with_most_games
  end

  def test_it_gets_season_with_fewest_games
    assert_equal 20152016, @stat_tracker.season_with_fewest_games
  end

  def test_it_gets_games_by_season
    expected = {"20122013" => @stat_tracker.games[0..5], "20152016" => @stat_tracker.games[6..9]}
    assert_equal expected, @stat_tracker.games_by_season
  end

  def test_it_gets_home_win_percentage_for_all_teams

    expected = { "6" => 100.0,
                  "3" => 50.0,
                  "24" => 0.0,
                  "19" => 50.0,
                  "16" => 0.0

    }
    assert_equal expected, @stat_tracker.home_win_percentage_per_team
  end

  def test_it_gets_away_win_percentage_for_all_teams

    expected = {  "6" => 50.0,
                  "3" => 0.0,
                  "17" => 100.0,
                  "19" => 100.0,
                  "16" => 50.0

    }
    assert_equal expected, @stat_tracker.away_win_percentage_per_team
  end

  def test_it_can_assign_home_and_away_percentages_to_teams

    @stat_tracker.assign_percentages_to_teams

    assert_equal 100.0, @stat_tracker.teams[0].home_win_percentage
    assert_equal 0.0, @stat_tracker.teams[1].away_win_percentage
  end

  def test_it_can_return_the_best_fans
    skip
    team_1 = mock
    team_2 = mock
    team_3 = mock

    team_1.expects(:team_name).returns("Bruins")

    team_1.expects(:home_win_percentage).returns(75)
    team_1.expects(:away_win_percentage).returns(25)

    team_2.expects(:home_win_percentage).returns(30)
    team_2.expects(:away_win_percentage).returns(0)

    team_3.expects(:home_win_percentage).returns(20)
    team_3.expects(:away_win_percentage).returns(50)


    @stat_tracker.teams = []
    @stat_tracker.teams = [team_1, team_2, team_3]

    assert_equal "Bruins", @stat_tracker.best_fans

  end

  def test_it_can_return_array_of_worst_fans
    skip

    team_1 = mock
    team_2 = mock
    team_3 = mock

    team_3.expects(:team_name).returns("Blackhawks")
    team_1.expects(:team_name).returns("Bruins")


    team_1.expects(:home_win_percentage).returns(25)
    team_1.expects(:away_win_percentage).returns(75)

    team_2.expects(:home_win_percentage).returns(30)
    team_2.expects(:away_win_percentage).returns(0)

    team_3.expects(:home_win_percentage).returns(20)
    team_3.expects(:away_win_percentage).returns(50)


    @stat_tracker.teams = []
    @stat_tracker.teams = [team_1, team_2, team_3]
    binding.pry

    assert_equal ["Bruins", "Blackhawks"], @stat_tracker.worst_fans
  end



end
