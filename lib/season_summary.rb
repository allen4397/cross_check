module SeasonSummary

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

  def season_summary(season_id, team_id)
    team = find_team(team_id)

    preseason_games = group_games_by_type_season_and_team("P", season_id, team_id)
    reg_season_games = group_games_by_type_season_and_team("R", season_id, team_id)

    preseason_hash = Hash.new(0)
    reg_season_hash = Hash.new(0)
    preseason_hash = {  :win_percentage => team.win_percentage(preseason_games),
                        :goals_scored => team.goals_scored(preseason_games),
                        :goals_against => team.goals_against(preseason_games)}

    reg_season_hash = { :win_percentage => team.win_percentage(reg_season_games),
                        :goals_scored => team.goals_scored(reg_season_games),
                        :goals_against => team.goals_against(reg_season_games)}

    {:preseason => preseason_hash, :regular_season => reg_season_hash}
  end


def seasonal_summary(team_id)
  team = find_team(team_id)

  seasons = seasons_by_team(team_id)
  summary = {}

  seasons.each do |season|
    preseason_games = group_games_by_type_season_and_team("P", season, team_id)
    reg_season_games = group_games_by_type_season_and_team("R", season, team_id)


    summary[season] = season_summary(season, team_id)
    summary[season][:preseason][:total_goals_scored] = summary[season][:preseason].delete(:goals_scored)
    summary[season][:preseason][:total_goals_against] = summary[season][:preseason].delete(:goals_against)

    summary[season][:regular_season][:total_goals_scored] = summary[season][:regular_season].delete(:goals_scored)
    summary[season][:regular_season][:total_goals_against] = summary[season][:regular_season].delete(:goals_against)

    summary[season][:preseason][:average_goals_scored] = team.average_goals_scored(preseason_games)
    summary[season][:preseason][:average_goals_against] = team.average_goals_against(preseason_games)

    summary[season][:regular_season][:average_goals_scored] = team.average_goals_scored(reg_season_games)
    summary[season][:regular_season][:average_goals_against] = team.average_goals_against(reg_season_games)

  end
  summary
end

end
