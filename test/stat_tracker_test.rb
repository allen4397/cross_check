require './test/test_helper'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/stat_tracker'
require 'pry'

class StatTrackerTest < Minitest::Test

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

  def test_it_exists

    assert_instance_of StatTracker, @stat_tracker
  end

  def test_it_creates_games_off_csv
    skip
    assert_instance_of Game, @stat_tracker.games[0]
    assert_equal 10, @stat_tracker.games.count
  end

  def test_it_creates_teams_off_csv
    skip
    assert_instance_of Team, @stat_tracker.teams[0]
    assert_equal 6, @stat_tracker.teams.count
  end

  def test_it_creates_game_teams_off_csv
    skip
    assert_instance_of GameTeam, @stat_tracker.game_teams[0]
    assert_equal 20, @stat_tracker.game_teams.count
  end

  def test_it_can_calculate_highest_total_score
    assert_equal 7, @stat_tracker.highest_total_score
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

  def test_it_counts_teams
    assert_equal 6, @stat_tracker.count_of_teams
  end

  def test_it_gets_games_by_all_team_ids
    skip
    gt = @stat_tracker.game_teams
    t3games = [gt[0], gt[2], gt[5], gt[7], gt[8]]
    t6games = [gt[1], gt[3], gt[4], gt[6], gt[9]]
    t17games = [gt[10]]
    t24games = [gt[11]]
    t16games = [gt[12], gt[14], gt[17], gt[19]]
    t19games = [gt[13], gt[15], gt[16], gt[18]]
    expected = {"3"=>t3games, "6"=>t6games, "17"=>t17games, "24"=>t24games, "16"=>t16games, "19"=>t19games}
    assert_equal expected, @stat_tracker.games_by_all_team_ids
  end

  def test_it_gets_games_by_team_id
    gt = @stat_tracker.game_teams
    t3games = [gt[0], gt[2], gt[5], gt[7], gt[8]]
    expected = t3games
    assert_equal expected, @stat_tracker.games_by_team_id("3")
  end

  def test_it_gets_team_total_score
    assert_equal 10, @stat_tracker.team_total_score("3")
  end

  def test_it_gets_game_count_by_team_id
    assert_equal 5, @stat_tracker.game_count_by_team_id("3")
  end

  def test_it_gets_average_score_by_team_id
    assert_equal 2.0, @stat_tracker.average_score_by_team_id("3")
  end

  def test_it_gets_best_offense_by_team_name
    #fails due to mismatch between team and team_games
    assert_equal "Bruins", @stat_tracker.best_offense_by_team_name
  end

  def test_it_gets_worst_offense_by_team_name
    #fails due to mismatch between team and team_name
    assert_equal "Blackhawks", @stat_tracker.worst_offense_by_team_name
  end

  def test_it_gets_opponnent_game_ids
    assert_equal ["2012030221", "2012030222", "2012030223", "2012030224", "2012030225"], @stat_tracker.get_opponent_team_game_ids("3")
  end

  def test_it_gets_opponent_game_teams
    gt = @stat_tracker.game_teams
    expected = [gt[1], gt[3], gt[4], gt[6], gt[9]]
    assert_equal expected, @stat_tracker.get_opponent_game_teams("3")
  end

  def test_it_gets_opponent_scores
    assert_equal 16, @stat_tracker.team_opponent_goals("3")
  end

  def test_it_gets_all_teams_opponent_averages
    expected = {"3" => 3.2, "6" => 2.0, "17" => 2.0, "24" => 3.0, "16" => 2.5, "7" => 4.0}
    assert_equal expected, @stat_tracker.all_teams_opponent_averages
  end

  def test_it_gets_best_defense
    assert_equal "Bruins", @stat_tracker.best_defense
  end

  def test_it_gets_worst_defense
    assert_equal "Sabres", @stat_tracker.worst_defense
  end

  def test_it_gets_team_name_from_id
    assert_equal "Blackhawks", @stat_tracker.get_team_name_from_id("16")
  end 

end
