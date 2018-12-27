require './test/test_helper'
require 'minitest/autorun'
require 'minitest/pride'
require 'mocha/minitest'
require './lib/stat_tracker'
require './lib/team_stats'
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
    skip
    expected = ["20122013", "20132014"]
    assert_equal expected, @stat_tracker.seasons_by_team("6")
  end

  def test_it_gets_games_by_team_id
    skip
    game = @stat_tracker.games
    expected = [game[0], game[1], game[2], game[3], game[4]]
    assert_equal expected, @stat_tracker.games_by_team_id("3")
  end

  def test_it_gets_games_by_season
    skip
    game = @stat_tracker.games
    expected = [game[6], game[7], game[8], game[9]]
    assert_equal expected, @stat_tracker.games_by_team_by_season("20152016", @stat_tracker.games)
  end

  def test_it_gets_games_by_season_for_team_id
    skip
    game = @stat_tracker.games
    expected = [game[10]]
    assert_equal expected, @stat_tracker.games_by_team_by_season("20132014", "6")
  end

  def test_it_gets_seasons_by_win_percentage_for_team
    skip
    expected = {"20122013" => 80.0, "20132014" => 100.0}
    assert_equal expected, @stat_tracker.seasons_by_win_percentage("6")
  end

  def test_it_gets_best_season
    skip
    assert_equal "20122013", @stat_tracker.best_season("6")
  end

  def test_it_gets_worst_season
    skip
    assert_equal "20132014", @stat_tracker.worst_season("6")
  end

  def test_it_averages_all_season_win_percentages_for_team
    skip
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

end






  # def test_it_gets_season_with_highest_win_percentage_for_a_team
  #   assert_equal "20122013", @stat_tracker.best_season
  # end
  #
  # def test_it_can_calculate_highest_total_score
  #   skip
  #   assert_equal 7, @stat_tracker.highest_total_score
  # end
  #
  # def test_it_can_calculate_percentage_of_games_won_by_home_team
  #   skip
  #   assert_equal 50.0, @stat_tracker.percentage_home_wins
  # end
  #
  # def test_it_can_calculate_percentage_of_games_won_by_away_team
  #   skip
  #   assert_equal 50.0, @stat_tracker.percentage_visitor_wins
  # end
  #
  # def test_it_can_calculate_average_goals_per_game
  #   skip
  #   assert_equal 4.9, @stat_tracker.average_goals_per_game
  # end
  #
  # def test_it_can_calculate_average_goals_by_season
  #   skip
  #   expected = {"20122013" => 5.17, "20152016" => 4.5}
  #   assert_equal expected, @stat_tracker.average_goals_by_season
  # end
  #
  # def test_it_calculates_lowest_total_score
  #   skip
  #   assert_equal 1, @stat_tracker.lowest_total_score
  # end
  #
  # def test_it_finds_biggest_blowout
  #   skip
  #   assert_equal 3, @stat_tracker.biggest_blowout
  # end
  #
  # def test_it_gets_game_count_by_venue
  #   skip
  #   expected = [["TD Garden", 3], ["Madison Square Garden", 2], ["Honda Center", 1], ["Scottrade Center", 2], ["United Center", 2]]
  #
  #   assert_equal expected, @stat_tracker.game_count_by_venue
  # end
  #
  # def test_it_gets_venue_with_most_games
  #   skip
  #   assert_equal "TD Garden", @stat_tracker.most_popular_venue
  # end
  #
  # def test_it_gets_venue_with_fewest_games
  #   skip
  #   assert_equal "Honda Center", @stat_tracker.least_popular_venue
  # end
  #
  # def test_it_gets_game_count_by_season
  #   skip
  #   expected = {"20122013" => 6, "20152016" => 4}
  #
  #   assert_equal expected, @stat_tracker.count_of_games_by_season
  # end
  #
  # def test_it_gets_season_with_most_games
  #   skip
  #   assert_equal 20122013, @stat_tracker.season_with_most_games
  # end
  #
  # def test_it_gets_season_with_fewest_games
  #   skip
  #   assert_equal 20152016, @stat_tracker.season_with_fewest_games
  # end
  #
  # def test_it_gets_games_by_season
  #   skip
  #   expected = {"20122013" => @stat_tracker.games[0..5], "20152016" => @stat_tracker.games[6..9]}
  #   assert_equal expected, @stat_tracker.games_by_season
  # end
  #
  # def test_it_can_calculate_highest_scoring_visitor
  #   skip
  #   assert_equal "Blues", @stat_tracker.highest_scoring_visitor
  # end
  #
  # def test_it_can_calculate_highest_scoring_home_team
  #   skip
  #   assert_equal "Bruins", @stat_tracker.highest_scoring_home_team
  # end
  #
  # def test_it_can_calculate_lowest_scoring_visitor
  #   skip
  #   assert_equal "Blackhawks", @stat_tracker.lowest_scoring_visitor
  # end
  #
  # def test_it_can_calculate_lowest_scoring_home_team
  #   skip
  #   assert_equal "Blues", @stat_tracker.lowest_scoring_home_team
  # end
  #
  # def test_it_can_calculate_winningest_team
  #   skip
  #   assert_equal "Red Wings", @stat_tracker.winningest_team
  # end
  #
  # def test_it_can_calculate_team_with_biggest_bust
  #   skip
  #   team_1 = mock
  #   team_2 = mock
  #   team_3 = mock
  #   team_4 = mock
  #
  #   game_1 = mock
  #   game_2 = mock
  #   game_3 = mock
  #   game_4 = mock
  #
  #   @stat_tracker.teams = [team_1, team_2, team_3, team_4]
  #   @stat_tracker.games = [game_1, game_2, game_3, game_4]
  #
  #   game_1.stubs(:season).returns("20122013")
  #   game_2.stubs(:season).returns("20122013")
  #   game_3.stubs(:season).returns("20122013")
  #   game_4.stubs(:season).returns("20122013")
  #
  #   game_1.stubs(:type).returns("P")
  #   game_2.stubs(:type).returns("P")
  #   game_3.stubs(:type).returns("R")
  #   game_4.stubs(:type).returns("R")
  #
  #   game_1.stubs(:outcome).returns("away")
  #   game_2.stubs(:outcome).returns("away")
  #   game_3.stubs(:outcome).returns("away")
  #   game_4.stubs(:outcome).returns("home")
  #
  #   game_1.stubs(:away_team_id).returns("1")
  #   game_2.stubs(:away_team_id).returns("2")
  #   game_3.stubs(:home_team_id).returns("3")
  #   game_4.stubs(:home_team_id).returns("4")
  #
  #   game_1.stubs(:home_team_id).returns("4")
  #   game_2.stubs(:home_team_id).returns("3")
  #   game_3.stubs(:away_team_id).returns("2")
  #   game_4.stubs(:away_team_id).returns("1")
  #
  #   team_1.stubs(:team_id).returns("1")
  #   team_2.stubs(:team_id).returns("2")
  #   team_3.stubs(:team_id).returns("3")
  #   team_4.stubs(:team_id).returns("4")
  #
  #   team_1.stubs(:team_name).returns("The Mighty Ducks")
  #   assert_equal "The Mighty Ducks", @stat_tracker.biggest_bust("20122013")
  # end
  #
  # def test_it_can_calculate_team_with_biggest_surprise
  #   skip
  #   team_1 = mock("1")
  #   team_2 = mock("2")
  #   team_3 = mock("3")
  #   team_4 = mock("4")
  #
  #   game_1 = mock
  #   game_2 = mock
  #   game_3 = mock
  #   game_4 = mock
  #
  #   @stat_tracker.teams = [team_1, team_2, team_3, team_4]
  #   @stat_tracker.games = [game_1, game_2, game_3, game_4]
  #
  #   game_1.stubs(:season).returns("20122013")
  #   game_2.stubs(:season).returns("20122013")
  #   game_3.stubs(:season).returns("20122013")
  #   game_4.stubs(:season).returns("20122013")
  #
  #   game_1.stubs(:type).returns("P")
  #   game_2.stubs(:type).returns("P")
  #   game_3.stubs(:type).returns("R")
  #   game_4.stubs(:type).returns("R")
  #
  #   game_1.stubs(:outcome).returns("away")
  #   game_2.stubs(:outcome).returns("away")
  #   game_3.stubs(:outcome).returns("away")
  #   game_4.stubs(:outcome).returns("home")
  #
  #   game_1.stubs(:away_team_id).returns("1")
  #   game_2.stubs(:away_team_id).returns("2")
  #   game_3.stubs(:home_team_id).returns("3")
  #   game_4.stubs(:home_team_id).returns("4")
  #
  #   game_1.stubs(:home_team_id).returns("4")
  #   game_2.stubs(:home_team_id).returns("3")
  #   game_3.stubs(:away_team_id).returns("2")
  #   game_4.stubs(:away_team_id).returns("1")
  #
  #   team_1.stubs(:team_id).returns("1")
  #   team_2.stubs(:team_id).returns("2")
  #   team_3.stubs(:team_id).returns("3")
  #   team_4.stubs(:team_id).returns("4")
  #
  #   team_4.stubs(:team_name).returns("Devils")
  #   assert_equal "Devils", @stat_tracker.biggest_surprise("20122013")
  # end
  #
  # def test_it_can_summarize_the_season
  #   skip
  #   team_1 = mock("1")
  #   team_2 = mock("2")
  #
  #   game_1 = mock
  #   game_2 = mock
  #   game_3 = mock
  #   game_4 = mock
  #
  #   @stat_tracker.teams = [team_1, team_2]
  #   @stat_tracker.games = [game_1, game_2, game_3, game_4]
  #
  #   game_1.stubs(:season).returns("20122013")
  #   game_2.stubs(:season).returns("20122013")
  #   game_3.stubs(:season).returns("20122013")
  #   game_4.stubs(:season).returns("20122013")
  #
  #   game_1.stubs(:type).returns("P")
  #   game_2.stubs(:type).returns("P")
  #   game_3.stubs(:type).returns("R")
  #   game_4.stubs(:type).returns("R")
  #
  #   game_1.stubs(:outcome).returns("away") # 1   3 to 1
  #   game_2.stubs(:outcome).returns("away") # 2    1 to 2
  #   game_3.stubs(:outcome).returns("away") # 2    3 to 4
  #   game_4.stubs(:outcome).returns("home") # 2    2 to 3
  #
  #   game_1.stubs(:away_team_id).returns("1")
  #   game_2.stubs(:away_team_id).returns("2")
  #   game_3.stubs(:home_team_id).returns("1")
  #   game_4.stubs(:home_team_id).returns("2")
  #
  #   game_1.stubs(:home_team_id).returns("2")
  #   game_2.stubs(:home_team_id).returns("1")
  #   game_3.stubs(:away_team_id).returns("2")
  #   game_4.stubs(:away_team_id).returns("1")
  #
  #   team_1.stubs(:team_id).returns("1")
  #   team_2.stubs(:team_id).returns("2")
  #
  #   expected = {preseason:      {win_percentage: 50.0,
  #                               goals_scored: 4,
  #                               goals_against: 3},
  #
  #               regular_season: {win_percentage: 0.0,
  #                               goals_scored: 5,
  #                               goals_against: 7}
  #               }
  #
  #   assert_equal expected, @stat_tracker.season_summary("20122013", "1")
  # end
  #
  # def test_it_can_return_home_win_percentage_for_a_team_in_a_selection_of_games
  #   skip
  #   assert_equal 100.0, @stat_tracker.home_win_percentages("6", @stat_tracker.games)
  # end
  #
  # def test_it_can_return_away_win_percentage_for_a_team_in_a_selection_of_games
  #   skip
  #   assert_equal 50.0, @stat_tracker.away_win_percentages("6", @stat_tracker.games)
  # end
  #
  # def test_it_gets_home_win_percentage_for_all_teams
  #   skip
  #   expected = { "6" => 100.0,
  #                 "3" => 50.0,
  #                 "24" => 0.0,
  #                 "19" => 50.0,
  #                 "16" => 0.0
  #
  #   }
  #   assert_equal expected, @stat_tracker.home_win_percentage_per_team
  # end
  #
  # def test_it_gets_away_win_percentage_for_all_teams
  #   skip
  #   expected = {  "6" => 50.0,
  #                 "3" => 0.0,
  #                 "17" => 100.0,
  #                 "19" => 100.0,
  #                 "16" => 50.0
  #
  #   }
  #   assert_equal expected, @stat_tracker.away_win_percentage_per_team
  # end
  #
  # def test_it_can_assign_home_and_away_percentages_to_teams
  #   skip
  #   @stat_tracker.assign_percentages_to_teams
  #
  #   assert_equal 100.0, @stat_tracker.teams[0].home_win_percentage
  #   assert_equal 0.0, @stat_tracker.teams[1].away_win_percentage
  # end
  #
  # def test_it_can_return_the_best_fans
  #   skip
  #   team_1 = mock
  #   team_2 = mock
  #   team_3 = mock
  #
  #   team_1.expects(:team_name).returns("Bruins")
  #
  #   team_1.expects(:home_win_percentage).returns(75)
  #   team_1.expects(:away_win_percentage).returns(25)
  #
  #   team_2.expects(:home_win_percentage).returns(30)
  #   team_2.expects(:away_win_percentage).returns(0)
  #
  #   team_3.expects(:home_win_percentage).returns(20)
  #   team_3.expects(:away_win_percentage).returns(50)
  #
  #
  #   @stat_tracker.teams = []
  #   @stat_tracker.teams = [team_1, team_2, team_3]
  #
  #   assert_equal "Bruins", @stat_tracker.best_fans
  # end
  #
  # def test_it_can_return_array_of_worst_fans
  #   skip
  #   team_1 = mock
  #   team_2 = mock
  #   team_3 = mock
  #
  #   team_3.expects(:team_name).returns("Blackhawks")
  #   team_1.expects(:team_name).returns("Bruins")
  #
  #
  #   team_1.expects(:home_win_percentage).returns(25)
  #   team_1.expects(:away_win_percentage).returns(75)
  #
  #   team_2.expects(:home_win_percentage).returns(30)
  #   team_2.expects(:away_win_percentage).returns(0)
  #
  #   team_3.expects(:home_win_percentage).returns(20)
  #   team_3.expects(:away_win_percentage).returns(50)
  #
  #   @stat_tracker.teams = []
  #   @stat_tracker.teams = [team_1, team_2, team_3]
  #
  #   assert_equal ["Bruins", "Blackhawks"], @stat_tracker.worst_fans
  # end
  #
  # def test_it_can_group_games_by_season_and_type_for_a_team
  #   skip
  #   game_1 = @stat_tracker.games.find do |game|
  #     game.game_id == "2015030161"
  #   end
  #
  #   game_2 = @stat_tracker.games.find do |game|
  #     game.game_id == "2015030162"
  #   end
  #
  #   game_3 = @stat_tracker.games.find do |game|
  #     game.game_id == "2015030163"
  #   end
  #
  #   game_4 = @stat_tracker.games.find do |game|
  #     game.game_id == "2015030164"
  #   end
  #
  #   expected = {preseason: [game_1, game_2, game_3, game_4],
  #               regular_season: []}
  #
  #   assert_equal expected, @stat_tracker.games_by_season_type("20152016","16")
  #
  # end
  #
  # def test_it_can_calculate_win_percentage_for_a_team_across_given_games
  #   skip
  #   assert_equal 80.0 , @stat_tracker.win_percentage("6", @stat_tracker.games)
  # end
  #
  # def test_it_can_calculate_goals_scored
  #   skip
  #   assert_equal 16, @stat_tracker.goals_scored("6",@stat_tracker.games)
  # end
  #
  # def test_it_counts_teams
  #   skip
  #   assert_equal 6, @stat_tracker.count_of_teams
  # end
  #
  # def test_it_gets_games_by_all_team_ids
  #   skip
  #   gt = @stat_tracker.game_teams
  #   t3games = [gt[0], gt[2], gt[5], gt[7], gt[8]]
  #   t6games = [gt[1], gt[3], gt[4], gt[6], gt[9]]
  #   t17games = [gt[10]]
  #   t24games = [gt[11]]
  #   t16games = [gt[12], gt[14], gt[17], gt[19]]
  #   t19games = [gt[13], gt[15], gt[16], gt[18]]
  #   expected = {"3"=>t3games, "6"=>t6games, "17"=>t17games, "24"=>t24games, "16"=>t16games, "19"=>t19games}
  #   assert_equal expected, @stat_tracker.games_by_all_team_ids
  # end
  #
  # def test_it_gets_game_teams_by_team_id
  #   skip
  #   gt = @stat_tracker.game_teams
  #   t3games = [gt[0], gt[2], gt[5], gt[7], gt[8]]
  #   expected = t3games
  #   assert_equal expected, @stat_tracker.games_by_team_id("3")
  # end
  #
  # def test_it_gets_team_total_score
  #   skip
  #   assert_equal 10, @stat_tracker.team_total_score("3")
  # end
  #
  # def test_it_gets_game_count_by_team_id
  #   skip
  #   assert_equal 5, @stat_tracker.game_count_by_team_id("3")
  # end
  #
  # def test_it_gets_average_score_by_team_id
  #   skip
  #   assert_equal 2.0, @stat_tracker.average_score_by_team_id("3")
  # end
  #
  # def test_it_gets_best_offense_by_team_name
  #   skip
  #   #fails due to mismatch between team and team_games
  #   assert_equal "Bruins", @stat_tracker.best_offense_by_team_name
  # end
  #
  # def test_it_gets_worst_offense_by_team_name
  #   skip
  #   #fails due to mismatch between team and team_name
  #   assert_equal "Blackhawks", @stat_tracker.worst_offense_by_team_name
  # end
  #
  # def test_it_gets_opponnent_game_ids
  #   skip
  #   assert_equal ["2012030221", "2012030222", "2012030223", "2012030224", "2012030225"], @stat_tracker.get_opponent_team_game_ids("3")
  # end
  #
  # def test_it_gets_opponent_game_teams
  #   skip
  #   gt = @stat_tracker.game_teams
  #   expected = [gt[1], gt[3], gt[4], gt[6], gt[9]]
  #   assert_equal expected, @stat_tracker.get_opponent_game_teams("3")
  # end
  #
  # def test_it_gets_opponent_scores
  #   skip
  #   assert_equal 16, @stat_tracker.team_opponent_goals("3")
  # end
  #
  # def test_it_gets_all_teams_opponent_averages
  #   skip
  #   expected = {"3" => 3.2, "6" => 2.0, "17" => 2.0, "24" => 3.0, "16" => 2.5, "7" => 4.0}
  #   assert_equal expected, @stat_tracker.all_teams_opponent_averages
  # end
  #
  # def test_it_gets_best_defense
  #   skip
  #   assert_equal "Bruins", @stat_tracker.best_defense
  # end
  #
  # def test_it_gets_worst_defense
  #   skip
  #   assert_equal "Sabres", @stat_tracker.worst_defense
  # end
  #
  # def test_it_gets_team_name_from_id
  #   skip
  #   assert_equal "Blackhawks", @stat_tracker.get_team_name_from_id("16")
  # end
