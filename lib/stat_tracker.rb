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


class StatTracker
  include TeamStats, GameStats, GameTeamStats, SeasonStats, VenueStats, WinPercentagesStats, LeagueStats

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


  def best_fans
    best_fans_team = @teams.max_by do |team|
      team.home_win_percentage - team.away_win_percentage
    end
    best_fans_team.team_name
  end

  def worst_fans
    worst_fans_teams = @teams.select do |team|
      team.away_win_percentage > team.home_win_percentage
    end

    worst_fans_teams.map do |team|
      team.team_name
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

  def get_team_name_from_id(team_id)
    team_name = nil

    @teams.each do |team|
      if team.team_id == team_id
        team_name = team.team_name
      end
    end

    team_name
  end


  def get_opponent_goals(team_id, games = @games)
    goals = 0
    games.each do |game|
      if game.away_team_id == team_id
        goals += game.home_goals
      elsif game.home_team_id == team_id
        goals += game.away_goals
      end
    end
    goals
  end

  def head_to_head(team_id, opponent_team_id)
    game_teams = game_teams_by_team_id(team_id)
    opponent_game_teams = game_teams_by_team_id(opponent_team_id)
    wins = 0
    losses = 0

    if game_teams && opponent_game_teams
      game_teams.each do |g_t|
        opponent_game_teams.each do |opp_g_t|

          if g_t.game_id == opp_g_t.game_id
            if g_t.won == "TRUE"
              wins += 1
            else
              losses += 1
            end
          end

        end
      end
    end
    {win: wins, loss: losses}
  end

end
