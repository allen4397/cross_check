require './test/test_helper'
require 'minitest/autorun'
require 'minitest/pride'
require 'mocha/minitest'
require './lib/stat_tracker'
require './lib/teams_info'
require './lib/team_statistics'
require './lib/team'
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
    assert_instance_of Game, @stat_tracker.games[0]
    assert_equal 11, @stat_tracker.games.count
  end

  def test_it_creates_teams_off_csv
    assert_instance_of Team, @stat_tracker.teams[0]
    assert_equal 6, @stat_tracker.teams.count
  end

  def test_it_creates_game_teams_off_csv
    assert_instance_of GameTeam, @stat_tracker.game_teams[0]
    assert_equal 22, @stat_tracker.game_teams.count
  end

  def test_team_stats_module
    assert_equal "THIS MODULE WORKS!", @stat_tracker.test_module
  end

  def test_it_gets_team_info
    expected = {"franchise_id" => "10",
                "short_name" => "NY Rangers",
                "team_name" => "Rangers",
                "abbreviation" => "NYR",
                "link" => "/api/v1/teams/3",
                "team_id" => "3"}

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
    assert_equal 0.80, stat_tracker_2.percentage_home_wins
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
    assert_equal 0.20, stat_tracker_2.percentage_visitor_wins
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
    expected = {"20122013" => 6, "20152016" => 4, "20132014" => 1}

    assert_equal expected, @stat_tracker.count_of_games_by_season
  end

  def test_it_gets_season_with_most_games
    assert_equal 20122013, @stat_tracker.season_with_most_games
  end

  def test_it_gets_season_with_fewest_games

    assert_equal 20132014, @stat_tracker.season_with_fewest_games
  end

  def test_it_gets_games_by_season

    assert_instance_of Hash, @stat_tracker.all_games_by_season
    assert_instance_of Game, @stat_tracker.all_games_by_season.values.first.first
    assert_equal 6, @stat_tracker.all_games_by_season["20122013"].count
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
    assert_equal "Bruins", @stat_tracker.winningest_team
  end

  def test_it_can_calculate_team_with_biggest_bust
    game_path = './data/extra_test_game.csv'
    team_path = './data/extra_test_team.csv'
    game_teams_path = './data/test_game_team_stats.csv'

    locations = {
     games: game_path,
     teams: team_path,
     game_teams: game_teams_path
    }

    stat_tracker_2 = StatTracker.from_csv(locations)
    assert_equal "Bruins", stat_tracker_2.biggest_bust("20122013")
  end

  def test_it_can_calculate_team_with_biggest_surprise
    game_path = './data/extra_test_game.csv'
    team_path = './data/extra_test_team.csv'
    game_teams_path = './data/test_game_team_stats.csv'

    locations = {
     games: game_path,
     teams: team_path,
     game_teams: game_teams_path
    }

    stat_tracker_2 = StatTracker.from_csv(locations)
    assert_equal "Rangers", stat_tracker_2.biggest_surprise("20122013")
  end

  def test_it_can_return_home_win_percentage_for_a_team_in_a_selection_of_games
    assert_equal 1.0, @stat_tracker.home_win_percentages("6", @stat_tracker.games)
  end

  def test_home_win_percentage_is_zero_if_team_has_not_played_at_home
    team_1 = mock
    team_2 = mock
    game_1 = mock
    game_2 = mock

    team_1.stubs(:team_id).returns("6")
    team_2.stubs(:team_id).returns("2")

    game_1.stubs(:home_team_id).returns("2")
    game_1.stubs(:away_team_id).returns("6")
    game_2.stubs(:home_team_id).returns("2")
    game_2.stubs(:away_team_id).returns("6")

    game_1.stubs(:outcome).returns("home win")
    game_2.stubs(:outcome).returns("away win")

    assert_equal 0.0, @stat_tracker.home_win_percentages("6", [game_1, game_2])
  end

  def test_it_can_return_away_win_percentage_for_a_team_in_a_selection_of_games
    assert_equal 0.50, @stat_tracker.away_win_percentages("6", @stat_tracker.games)
  end

  def test_away_win_percentage_is_zero_if_team_has_not_played_away_games
    team_1 = mock
    team_2 = mock
    game_1 = mock
    game_2 = mock

    team_1.stubs(:team_id).returns("1")
    team_2.stubs(:team_id).returns("6")

    game_1.stubs(:home_team_id).returns("6")
    game_1.stubs(:away_team_id).returns("1")
    game_2.stubs(:home_team_id).returns("6")
    game_2.stubs(:away_team_id).returns("1")

    game_1.stubs(:outcome).returns("home win")
    game_2.stubs(:outcome).returns("away win")

    assert_equal 0.0, @stat_tracker.away_win_percentages("6", [game_1, game_2])
  end

  def test_it_gets_home_win_percentage_for_all_teams
    expected = { "6" => 1.0,
                  "3" => 0.50,
                  "24" => 0.0,
                  "19" => 0.50,
                  "16" => 0.0

    }
    assert_equal expected, @stat_tracker.home_win_percentage_per_team
  end

  def test_it_gets_away_win_percentage_for_all_teams
    expected = {  "6" => 0.50,
                  "3" => 0.0,
                  "17" => 0.50,
                  "19" => 1.0,
                  "16" => 0.50
                }
    assert_equal expected, @stat_tracker.away_win_percentage_per_team
  end

  def test_it_can_assign_home_and_away_percentages_to_teams

    @stat_tracker.assign_percentages_to_teams

    assert_equal 1.0, @stat_tracker.teams[0].home_win_percentage
    assert_equal 0.0, @stat_tracker.teams[1].away_win_percentage
  end

  def test_it_can_return_the_best_fans
    assert_equal "Bruins", @stat_tracker.best_fans
  end

  def test_it_can_return_array_of_worst_fans
    assert_equal ["Blackhawks", "Red Wings", "Blues"], @stat_tracker.worst_fans
  end

  def test_it_can_calculate_win_percentage_for_a_team_across_given_games
    assert_equal 0.83 , @stat_tracker.teams[0].win_percentage(@stat_tracker.games)
  end

  def test_it_can_calculate_goals_scored
    bruins = @stat_tracker.teams.find do |team|
      team.team_id == "6"
    end
    assert_equal 20, bruins.goals_scored(@stat_tracker.games)
  end

  def test_it_counts_teams
    assert_equal 6, @stat_tracker.count_of_teams
  end

  def test_it_gets_games_by_all_team_ids #add comments to know what t3 games are etc
    gt = @stat_tracker.game_teams
    t3games = [gt[0], gt[2], gt[5], gt[7], gt[8]]
    t6games = [gt[1], gt[3], gt[4], gt[6], gt[9], gt[21]]
    t17games = [gt[10], gt[20]]
    t24games = [gt[11]]
    t16games = [gt[12], gt[14], gt[17], gt[19]]
    t19games = [gt[13], gt[15], gt[16], gt[18]]

    expected = {"3"=>t3games, "6"=>t6games, "17"=>t17games, "24"=>t24games, "16"=>t16games, "19"=>t19games}

    assert_equal expected, @stat_tracker.game_teams_by_all_team_ids
  end

  def test_it_gets_games_by_team_id
    gt = @stat_tracker.game_teams
    t3games = [gt[0], gt[2], gt[5], gt[7], gt[8]]
    expected = t3games
    assert_equal expected, @stat_tracker.game_teams_by_team_id("3")
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
    assert_equal "Bruins", @stat_tracker.best_offense
  end

  def test_it_gets_worst_offense_by_team_name
    assert_equal "Rangers", @stat_tracker.worst_offense
  end

  def test_it_gets_opponent_game_ids
    assert_equal ["2012030221", "2012030222", "2012030223", "2012030224", "2012030225"], @stat_tracker.opponent_team_game_ids("3")
  end

  def test_it_gets_opponent_game_teams
    gt = @stat_tracker.game_teams
    expected = [gt[1], gt[3], gt[4], gt[6], gt[9]]
    assert_equal expected, @stat_tracker.opponent_game_teams("3")
  end

  def test_it_gets_opponent_scores
    assert_equal 16, @stat_tracker.team_opponent_goals("3")
  end

  def test_it_gets_all_teams_opponent_averages
    expected = {"3" => 3.2, "6" => 2.0, "17" => 2.5, "24" => 3.0, "16" => 2.5, "19" => 1.5}
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

  def test_it_can_return_an_array_of_games_by_season_type
    assert_instance_of Game, @stat_tracker.group_games_by_season_type("P").first
    assert_equal "P", @stat_tracker.group_games_by_season_type("P").first.type
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

                regular_season: { win_percentage: 0.33,
                                  goals_scored: 6,
                                  goals_against: 9 }
                }

    assert_equal expected, stat_tracker_2.season_summary("20122013", "3")
  end

  def test_it_can_group_games_by_season_and_team
    assert_equal 5, @stat_tracker.games_by_team_by_season("20122013", "6").count
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

    games = [game_1, game_2, game_3, game_4]

    assert_equal [game_1, game_3, game_4], @stat_tracker.find_games_by_team_id("1", games)
  end

  def test_it_groups_games_by_season_type

    assert_instance_of Game, @stat_tracker.group_games_by_season_type("P").first
    assert_equal "P", @stat_tracker.group_games_by_season_type("P").first.type
  end

  def test_it_can_return_a_seasonal_summary_for_a_given_team
    game_path = './data/extra_test_game.csv'
    team_path = './data/extra_test_team.csv'
    game_teams_path = './data/extra_game_team.csv'

    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }

    stat_tracker_2 = StatTracker.from_csv(locations)

    expected = {"20122013" => {
      preseason: {
                            win_percentage: 0.0,
                            total_goals_scored: 4,
                            total_goals_against: 8,
                            average_goals_scored: 2.0,
                            average_goals_against: 4.0
                            } ,

      regular_season: {
                            win_percentage: 0.33,
                            total_goals_scored: 6,
                            total_goals_against: 9,
                            average_goals_scored: 2.0,
                            average_goals_against: 3.0
                          }
                                              }

             }
    assert_equal expected, stat_tracker_2.seasonal_summary("3")
  end

  def test_it_can_provide_head_to_head_record_against_a_specific_opponent
    expected = {
              "Bruins" => 0.2,
              "Ducks"=>0,
              "Blackhawks"=>0,
              "Red Wings"=>0,
              "Blues"=>0
             }

    assert_equal expected, @stat_tracker.head_to_head("3")
  end

  def test_game_stats_module_works
    assert_equal "Game stats module works!", @stat_tracker.game_stats_module_works
  end

  def test_it_can_group_games_by_season_team_and_type

    game_path = './data/extra_test_game.csv'
    team_path = './data/extra_test_team.csv'
    game_teams_path = './data/extra_game_team.csv'

    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }

    stat_tracker_2 = StatTracker.from_csv(locations)

    game_1 = stat_tracker_2.games[0]
    game_2 = stat_tracker_2.games[1]
    assert_equal [game_1, game_2], stat_tracker_2.group_games_by_type_season_and_team("P", "20122013", "3")
  end

  def test_it_gets_seasons_by_win_percentage_for_team
     expected = {"20122013" => 0.80, "20132014" => 1.0}
     assert_equal expected, @stat_tracker.seasons_by_win_percentage("6")
  end

  def test_it_gets_opponent_team_ids
    assert_equal ["3", "17"], @stat_tracker.opponent_team_ids("6")
  end

  def test_it_gets_opponents_by_win_percentage
    expected = {"3"=>0.20, "17"=>0.00}
    assert_equal expected, @stat_tracker.opponents_by_win_percentage("6")
  end

  def test_it_can_calculate_biggest_team_blowout
    assert_equal 3, @stat_tracker.biggest_team_blowout("6")
  end

  def test_it_can_calculate_worst_loss
    assert_equal 1, @stat_tracker.worst_loss("6")
  end

  def test_it_gets_opponent_with_lowest_win_percentage
    assert_equal "Red Wings", @stat_tracker.favorite_opponent("6")
  end

  def test_it_gets_opponent_with_highest_win_percentage
    assert_equal "Rangers", @stat_tracker.rival("6")
  end

  def test_it_gets_best_season
    assert_equal "20132014", @stat_tracker.best_season("6")
  end

  def test_it_gets_worst_season
    assert_equal "20122013", @stat_tracker.worst_season("6")
  end

  def test_it_averages_all_season_win_percentages_for_team

    assert_equal 0.83, @stat_tracker.average_win_percentage("6")
  end

  def test_it_gets_highest_goals_for_team
    assert_equal 5, @stat_tracker.most_goals_scored("6")
  end

  def test_it_gets_fewest_goals_for_team
    assert_equal 2, @stat_tracker.fewest_goals_scored("6")
  end
end
