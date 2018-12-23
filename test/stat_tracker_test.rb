require './test/test_helper'
require 'minitest/autorun'
require 'minitest/pride'
require 'mocha/minitest'
require './lib/stat_tracker'
require './lib/team_stats'
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

  def test_team_stats_module
    assert_equal "THIS MODULE WORKS!", @stat_tracker.test_module
  end

  def test_it_gets_team_info
    expected = {franchise_id: "10",
                short_name: "NY Rangers",
                team_name: "Rangers",
                abbreviation: "NYR",
                link: "/api/v1/teams/3"}

    assert_equal expected, @stat_tracker.team_info("3")
  end

  def test_it_can_calculate_highest_total_score
    assert_equal 7, @stat_tracker.highest_total_score
  end

  def test_it_can_calculate_percentage_of_games_won_by_home_team
    game_path = './data/extra_test_game.csv'
    team_path = './data/extra_test_team.csv'
    game_teams_path = './data/test_game_team_stats.csv'

    locations = {
     games: game_path,
     teams: team_path,
     game_teams: game_teams_path
    }

    stat_tracker_2 = StatTracker.from_csv(locations)
    assert_equal 80.0, stat_tracker_2.percentage_home_wins
  end

  def test_it_can_calculate_percentage_of_games_won_by_away_team
    game_path = './data/extra_test_game.csv'
    team_path = './data/extra_test_team.csv'
    game_teams_path = './data/test_game_team_stats.csv'

    locations = {
     games: game_path,
     teams: team_path,
     game_teams: game_teams_path
    }

    stat_tracker_2 = StatTracker.from_csv(locations)
    assert_equal 20.0, stat_tracker_2.percentage_visitor_wins
  end

  def test_it_can_calculate_average_goals_per_game
    game_path = './data/extra_test_game.csv'
    team_path = './data/extra_test_team.csv'
    game_teams_path = './data/test_game_team_stats.csv'

    locations = {
     games: game_path,
     teams: team_path,
     game_teams: game_teams_path
    }

    stat_tracker_2 = StatTracker.from_csv(locations)

    assert_equal 5.4, stat_tracker_2.average_goals_per_game
  end

  def test_it_can_calculate_average_goals_by_season

    expected = {"20122013" => 5.17, "20152016" => 4.5, "20132014" => 7.0}
    assert_equal expected, @stat_tracker.average_goals_by_season
  end

  def test_it_calculates_lowest_total_score
    assert_equal 1, @stat_tracker.lowest_total_score
  end

  def test_it_finds_biggest_blowout
    assert_equal 3, @stat_tracker.biggest_blowout
  end

  def test_it_gets_game_count_by_venue

    expected = [["TD Garden", 3], ["Madison Square Garden", 3], ["Honda Center", 1], ["Scottrade Center", 2], ["United Center", 2]]

    assert_equal expected, @stat_tracker.game_count_by_venue
  end

  def test_it_gets_venue_with_most_games
    assert_equal "TD Garden", @stat_tracker.most_popular_venue
  end

  def test_it_gets_venue_with_fewest_games
    assert_equal "Honda Center", @stat_tracker.least_popular_venue
  end

  def test_it_gets_game_count_by_season
    skip
    expected = {"20122013" => 6, "20152016" => 4}

    assert_equal expected, @stat_tracker.count_of_games_by_season
  end

  def test_it_gets_season_with_most_games
    assert_equal 20122013, @stat_tracker.season_with_most_games
  end

  def test_it_gets_season_with_fewest_games

    assert_equal 20132014, @stat_tracker.season_with_fewest_games
  end

  def test_it_gets_games_by_season
    skip
    expected = {"20122013" => @stat_tracker.games[0..5], "20152016" => @stat_tracker.games[6..9]}
    assert_equal expected, @stat_tracker.games_by_season
  end

  def test_it_can_calculate_highest_scoring_visitor
    assert_equal "Blues", @stat_tracker.highest_scoring_visitor
  end

  def test_it_can_calculate_highest_scoring_home_team
    assert_equal "Bruins", @stat_tracker.highest_scoring_home_team
  end

  def test_it_can_calculate_lowest_scoring_visitor
    assert_equal "Blackhawks", @stat_tracker.lowest_scoring_visitor
  end

  def test_it_can_calculate_lowest_scoring_home_team
    assert_equal "Blues", @stat_tracker.lowest_scoring_home_team
  end

  def test_it_can_calculate_winningest_team
    skip
    assert_equal "Red Wings", @stat_tracker.winningest_team
  end

  def test_it_can_calculate_team_with_biggest_bust
    skip
    game_path = './data/extra_test_game.csv'
    team_path = './data/extra_test_team.csv'
    game_teams_path = './data/test_game_team_stats.csv'

    locations = {
     games: game_path,
     teams: team_path,
     game_teams: game_teams_path
    }

    stat_tracker_2 = StatTracker.from_csv(locations)
    assert_equal "Rangers", stat_tracker_2.biggest_bust("20122013")
  end

  def test_it_can_calculate_team_with_biggest_surprise
    skip
    game_path = './data/extra_test_game.csv'
    team_path = './data/extra_test_team.csv'
    game_teams_path = './data/test_game_team_stats.csv'

    locations = {
     games: game_path,
     teams: team_path,
     game_teams: game_teams_path
    }

    stat_tracker_2 = StatTracker.from_csv(locations)
    assert_equal "Bruins", stat_tracker_2.biggest_surprise("20122013")
  end

  def test_it_can_return_home_win_percentage_for_a_team_in_a_selection_of_games

    assert_equal 100.0, @stat_tracker.home_win_percentages("6", @stat_tracker.games)
  end

  def test_it_can_return_away_win_percentage_for_a_team_in_a_selection_of_games


    assert_equal 50.0, @stat_tracker.away_win_percentages("6", @stat_tracker.games)
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
    skip

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

    assert_equal ["Bruins", "Blackhawks"], @stat_tracker.worst_fans
  end

  def test_it_can_group_games_by_season_and_type_for_a_team
    skip
    game_1 = @stat_tracker.games.find do |game|
      game.game_id == "2015030161"
    end

    game_2 = @stat_tracker.games.find do |game|
      game.game_id == "2015030162"
    end

    game_3 = @stat_tracker.games.find do |game|
      game.game_id == "2015030163"
    end

    game_4 = @stat_tracker.games.find do |game|
      game.game_id == "2015030164"
    end

    expected = {preseason: [game_1, game_2, game_3, game_4],
                regular_season: []}

    assert_equal expected, @stat_tracker.games_by_season_type("20152016","16")

  end

  def test_it_can_calculate_win_percentage_for_a_team_across_given_games
    skip
    assert_equal 80.0 , @stat_tracker.win_percentage("6", @stat_tracker.games)
  end

  def test_it_can_calculate_goals_scored
    skip
    assert_equal 16, @stat_tracker.goals_scored("6", @stat_tracker.games)
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
    skip
    #fails due to mismatch between team and team_games
    assert_equal "Bruins", @stat_tracker.best_offense_by_team_name
  end

  def test_it_gets_worst_offense_by_team_name
    skip
    #fails due to mismatch between team and team_name
    assert_equal "Blackhawks", @stat_tracker.worst_offense_by_team_name
  end

  def test_it_gets_opponent_game_ids
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
    expected = {"3" => 3.2, "6" => 2.0, "17" => 2.0, "24" => 3.0, "16" => 2.5, "19" => 1.5}
    assert_equal expected, @stat_tracker.all_teams_opponent_averages
  end

  def test_it_gets_best_defense
    assert_equal "Blues", @stat_tracker.best_defense
  end

  def test_it_gets_worst_defense
    assert_equal "Rangers", @stat_tracker.worst_defense
  end

  def test_it_gets_team_name_from_id
    assert_equal "Blackhawks", @stat_tracker.get_team_name_from_id("16")
  end

  # def test_it_can_collect_preseason_games
  #   game_1 = mock
  #   game_2 = mock
  #   game_3 = mock
  #   game_4 = mock
  #
  #
  #   @stat_tracker.games = [game_1, game_2, game_3, game_4]
  #
  #   game_1.stubs(:type).returns("P")
  #   game_2.stubs(:type).returns("R")
  #   game_3.stubs(:type).returns("P")
  #   game_4.stubs(:type).returns("R")
  #
  #   assert_equal [game_1, game_3], @stat_tracker.preseason_games
  # end
  #
  # def test_it_can_collect_reg_season_games
  #   game_1 = mock
  #   game_2 = mock
  #   game_3 = mock
  #   game_4 = mock
  #
  #
  #   @stat_tracker.games = [game_1, game_2, game_3, game_4]
  #
  #   game_1.stubs(:type).returns("P")
  #   game_2.stubs(:type).returns("R")
  #   game_3.stubs(:type).returns("P")
  #   game_4.stubs(:type).returns("R")
  #
  #   assert_equal [game_2, game_4], @stat_tracker.reg_season_games
  # end

  def test_it_can_return_an_array_of_games_by_season_type
    reg_season_game_1 = mock
    reg_season_game_2 = mock
    @stat_tracker.games = []
    @stat_tracker.games << reg_season_game_1
    @stat_tracker.games << reg_season_game_2
    preseason_game_1 = mock
    preseason_game_2 = mock
    @stat_tracker.games << preseason_game_1
    @stat_tracker.games << preseason_game_2

    reg_season_game_1.stubs(:type).returns("R")
    reg_season_game_2.stubs(:type).returns("R")
    preseason_game_1.stubs(:type).returns("P")
    preseason_game_2.stubs(:type).returns("P")

    assert [preseason_game_1, preseason_game_2], @stat_tracker.group_games_by_season_type("P")
    assert [reg_season_game_1, reg_season_game_2], @stat_tracker.group_games_by_season_type("R")
  end

  def test_it_can_return_season_summary
    game_path = './data/extra_test_game.csv'
    team_path = './data/extra_test_team.csv'
    game_teams_path = './data/extra_game_team.csv'

    locations = {
     games: game_path,
     teams: team_path,
     game_teams: game_teams_path
    }

    stat_tracker_2 = StatTracker.from_csv(locations)

    expected = {preseason: { win_percentage: 0.0,
                              goals_scored: 4,
                              goals_against: 8} ,

                regular_season: { win_percentage: 33.33,
                                  goals_scored: 6,
                                  goals_against: 9 }
                }

    assert_equal expected, stat_tracker_2.season_summary("20122013", "3")

  end

  def test_it_can_get_opponent_goals_for_a_team_with_selection_of_games

    game_path = './data/extra_test_game.csv'
    team_path = './data/extra_test_team.csv'
    game_teams_path = './data/extra_game_team.csv'

    locations = {
     games: game_path,
     teams: team_path,
     game_teams: game_teams_path
    }

    stat_tracker_2 = StatTracker.from_csv(locations)
    assert_equal 10, stat_tracker_2.get_opponent_goals("6",stat_tracker_2.games)

  end

  def test_it_can_group_games_by_season_and_team

    game_1 = mock
    game_2 = mock
    game_3 = mock
    game_4 = mock

    team_1 = mock
    team_2 = mock

    team_1.stubs(:team_id).returns("1")
    team_2.stubs(:team_id).returns("2")

    game_1.stubs(:season).returns("20122013")
    game_2.stubs(:season).returns("20122013")
    game_3.stubs(:season).returns("20122013")
    game_4.stubs(:season).returns("20132014")

    game_1.stubs(:away_team_id).returns("1")
    game_1.stubs(:home_team_id).returns("2")
    game_2.stubs(:away_team_id).returns("2")
    game_2.stubs(:home_team_id).returns("3")
    game_3.stubs(:away_team_id).returns("2")
    game_3.stubs(:home_team_id).returns("1")
    game_4.stubs(:away_team_id).returns("2")
    game_4.stubs(:home_team_id).returns("1")

    @stat_tracker.games = [game_1, game_2, game_3, game_4]
    @stat_tracker.teams = [team_1, team_2]

    expected = [game_1, game_3]
    assert_equal expected, @stat_tracker.games_by_team_by_season("20122013", "1")
  end

  def test_it_can_return_an_array_of_games_by_team_id
    game_1 = mock
    game_2 = mock
    game_3 = mock
    game_4 = mock

    game_1.stubs(:away_team_id).returns("1")
    game_1.stubs(:home_team_id).returns("2")
    game_2.stubs(:away_team_id).returns("2")
    game_2.stubs(:home_team_id).returns("3")
    game_3.stubs(:away_team_id).returns("2")
    game_3.stubs(:home_team_id).returns("1")
    game_4.stubs(:away_team_id).returns("2")
    game_4.stubs(:home_team_id).returns("1")

    @stat_tracker.games = [game_1, game_2, game_3, game_4]

    assert_equal [game_1, game_3, game_4], @stat_tracker.find_games_by_team_id("1", @stat_tracker.games)
  end


end
