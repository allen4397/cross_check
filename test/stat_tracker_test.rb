require './test/test_helper'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/stat_tracker'

class StatTrackerTest < Minitest::Test
  def test_it_exists
    file = './data/test_game_team_stats.csv'
    stat_tracker = StatTracker.new(file)

    assert_instance_of StatTracker, stat_tracker
  end

  def test_it_creates_off_csv
    file = './data/test_game_team_stats.csv'
    stat_tracker_2 = StatTracker.from_csv(file)

    assert_instance_of StatTracker, stat_tracker_2
  end
end
