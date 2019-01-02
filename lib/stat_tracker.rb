require 'csv'
require_relative 'game'
require_relative 'team'
require 'pry'
require_relative 'game_team'
require_relative 'team_stats'
require_relative 'game_stats'
require_relative 'game_team_stats'
require_relative 'season_stats'
require_relative 'league_stats'
require_relative 'venue_stats'
require_relative 'win_percentages_stats'
require_relative 'season_summary'
require_relative 'team_statistics'


class StatTracker
  include TeamStats, GameStats, GameTeamStats, SeasonStats, VenueStats, WinPercentagesStats, LeagueStats, SeasonSummary, TeamStatistics

  attr_accessor :teams,
                :games,
                :game_teams

  attr_reader :team_stats

  def initialize(info_hash)
    @games = []
    game_instance(info_hash[:games])
    @teams = []
    team_instance(info_hash[:teams])
    assign_percentages_to_teams
    @game_teams = []
    game_team_instance(info_hash[:game_teams])
  end

  def self.from_csv(data)
    StatTracker.new(data)
  end

  def game_instance(game_file)
    CSV.foreach(game_file, headers: true, header_converters: :symbol) do |row|
      @games << Game.new(row)
    end
  end

  def team_instance(team_file)
    CSV.foreach(team_file, headers: true, header_converters: :symbol) do |row|
      team = Team.new(row)
      @teams << team
    end
  end

  def game_team_instance(game_team_file)
    CSV.foreach(game_team_file, headers: true, header_converters: :symbol) do |row|
      @game_teams << GameTeam.new(row)
    end
  end


  def average_score_by_team_id(team_id)
    team_total_score(team_id).to_f / game_count_by_team_id(team_id).to_f
  end



  def all_teams_opponent_averages
    all_teams = {}

    @teams.each do |team|
      all_teams[team.team_id] = (team_opponent_goals(team.team_id))/game_count_by_team_id(team.team_id).to_f
    end

    all_teams
  end

  def get_average_goals_against(team_id, games)
    team = find_team(team_id)

    if team.games_played_in(games).count != 0
      (get_opponent_goals(team_id,games).to_f / team.games_played_in(games).count).round(2)
    else
      return 0.0
    end
  end






end
