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

  def win_percentage(games)
    (number_of_games_won(games)/games_played_in(games).count.to_f * 100).round(2)
  end

  def number_of_games_won(games)
    games_won = 0
    games.each do |game|
      if game.away_team_id == @team_id && game.outcome.include?("away") || game.home_team_id == @team_id && game.outcome.include?("home")
        games_won += 1
      end
    end
    return games_won
  end

  def games_played_in(games)
    games.find_all do |game|
      game.away_team_id == @team_id || game.home_team_id == @team_id
    end
  end

  def total_away_points(games)
    games.sum do |game|
      if team_id == game.away_team_id
        game.away_goals
      else
        0
      end
    end
  end

  def total_home_points(games)
    games.sum do |game|
      if team_id == game.home_team_id
        game.home_goals
      else
        0
      end
    end
  end

  def goals_scored(games)
    total_home_points(games) + total_away_points(games)
  end

  def games_played_as_visitor(games)
    games.count do |game|
      game.away_team_id == team_id
    end
  end

  def games_played_as_home_team(games)
    games.count do |game|
      game.home_team_id == team_id
    end
  end


end
