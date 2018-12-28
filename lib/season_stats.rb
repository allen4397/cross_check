module SeasonStats

  def season_with_most_games
    highest_count = count_of_games_by_season.values.max
    count_of_games_by_season.key(highest_count).to_i
  end

  def season_with_fewest_games
    lowest_count = count_of_games_by_season.values.min
    count_of_games_by_season.key(lowest_count).to_i
  end

  def count_of_games_by_season
    game_count_by_season = {}
    all_games_by_season.each do |season, games|
      game_count_by_season[season] = games.count
    end
    return game_count_by_season
  end

  def group_games_by_season_type(type, games = @games)
    games.select do |game|
      game.type == type
    end
  end

  def seasons_by_win_percentage(team_id)
    win_perc_seasons = {}
    seasons_by_team(team_id).each do |season|
      win_perc_seasons[season] = find_team(team_id).win_percentage(games_by_team_by_season(season, team_id))
    end
    return win_perc_seasons
  end

  def best_season(team_id)
    highest_win_percentage = seasons_by_win_percentage(team_id).values.max
    seasons_by_win_percentage(team_id).key(highest_win_percentage)
  end

  def worst_season(team_id)
    lowest_win_percentage = seasons_by_win_percentage(team_id).values.min
    seasons_by_win_percentage(team_id).key(lowest_win_percentage)
  end

  def average_win_percentage(team_id)
    total = seasons_by_win_percentage(team_id).values.sum
    count = seasons_by_win_percentage(team_id).count
    total / count
  end

  def season_summary(season_id, team_id)
    team = find_team(team_id)

    games = games_by_team_by_season(season_id, team_id)
    preseason = group_games_by_season_type("P", games)
    reg_season = group_games_by_season_type("R", games)

    preseason_hash = Hash.new(0)
    reg_season_hash = Hash.new(0)
    preseason_hash = {  :win_percentage => team.win_percentage(preseason),
                        :goals_scored => team.goals_scored(preseason),
                        :goals_against => get_opponent_goals(team_id, preseason)}

    reg_season_hash = { :win_percentage => team.win_percentage(reg_season),
                        :goals_scored => team.goals_scored(reg_season),
                        :goals_against => get_opponent_goals(team_id, reg_season)}

        {:preseason => preseason_hash,
        :regular_season => reg_season_hash}
  end

  def seasonal_summary(team_id)
    team = find_team(team_id)

    seasons = seasons_by_team(team_id)
    summary = {}

    seasons.each do |season|
      games = games_by_team_by_season(season, team_id)
      preseason = group_games_by_season_type("P", games)
      reg_season = group_games_by_season_type("R", games)

      summary[season] = season_summary(season, team_id)
      summary[season][:preseason][:total_goals_scored] = summary[season][:preseason].delete(:goals_scored)
      summary[season][:preseason][:total_goals_against] = summary[season][:preseason].delete(:goals_against)
      summary[season][:regular_season][:total_goals_scored] = summary[season][:regular_season].delete(:goals_scored)
      summary[season][:regular_season][:total_goals_against] = summary[season][:regular_season].delete(:goals_against)

      if preseason.count != 0
        average_goals_scored = ((team.goals_scored(preseason).to_f) / (preseason.count)).round(2)
        average_goals_against = (get_opponent_goals(team_id, preseason).to_f / preseason.count).round(2)
      else
        average_goals_scored = 0
        average_goals_against = 0

      end

      summary[season][:preseason][:average_goals_scored] = average_goals_scored
      summary[season][:preseason][:average_goals_against] = average_goals_against

      if reg_season.count != 0
        average_goals_scored_reg = ((team.goals_scored(reg_season).to_f) / (reg_season.count)).round(2)
        average_goals_against_reg = (get_opponent_goals(team_id, reg_season).to_f / reg_season.count).round(2)
      else
        average_goals_scored_reg = 0
        average_goals_against_reg = 0
      end

      summary[season][:regular_season][:average_goals_scored] = average_goals_scored_reg
      summary[season][:regular_season][:average_goals_against] = average_goals_against_reg

    end #end of each
    summary

  end


  def biggest_bust(season_id)
    regular_season = group_games_by_season_type("R", all_games_by_season[season_id])
    preseason = group_games_by_season_type("P", all_games_by_season[season_id])
    largest_decrease_in_percentage = @teams.max_by do |team|
      team.win_percentage(preseason)/team.win_percentage(regular_season)
      end
    largest_decrease_in_percentage.team_name
  end

  def biggest_surprise(season_id)
    regular_season = group_games_by_season_type("R", all_games_by_season[season_id])
    preseason = group_games_by_season_type("P", all_games_by_season[season_id])
    largest_increase_in_percentage = @teams.max_by do |team|
      team.win_percentage(regular_season)/team.win_percentage(preseason)
      end
    largest_increase_in_percentage.team_name
  end



end
