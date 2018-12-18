require './test/test_helper'
require 'minitest/autorun'
require 'minitest/pride'
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
                franchise_id: "23",
                short_name: "New Jersey",
                team_name: "Devils",
                abbreviation: "NJD",
                link: "/api/v1/teams/1"
    }

    test_team = @stat_tracker.teams[0]

    assert_equal expected, test_team.provide_info

  end






end
