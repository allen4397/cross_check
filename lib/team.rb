require "csv"
require 'pry'
require './lib/stat_tracker'

class Team

  attr_reader :team_id,
              :team_name

  attr_accessor :away_win_percentage,
                :home_win_percentage

  def initialize(team_info)
    @team_id = team_info[:team_id]
    @franchise_id = team_info[:franchiseid]
    @short_name = team_info[:shortname]
    @team_name = team_info[:teamname]
    @abbreviation = team_info[:abbreviation]
    @link = team_info[:link]
    @away_win_percentage = 0
    @home_win_percentage = 0
    @pre_season_win_percentage = 0
    @post_season_win_percentage = 0
  end

  def provide_info
                { franchise_id: @franchise_id,
                  short_name: @short_name,
                  team_name: @team_name,
                  abbreviation: @abbreviation,
                  link: @link}
  end

  







end
