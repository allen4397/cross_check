module GameTeamStats

  def opponent_team_game_ids(team_id)
    game_teams_by_team_id(team_id).map do |gt|
      gt.game_id
    end
  end

  def opponent_game_teams(team_id)
    opponent_team_game_ids(team_id).map do |game_id|
      game_teams.find do |gt|
        gt.game_id == game_id && gt.team_id != team_id
      end
    end
  end

  def team_opponent_goals(team_id)
    opponent_game_teams(team_id).sum do |gt|
      gt.goals.to_i
    end
  end

  def all_teams_opponent_averages
    @all_teams_opponent_averages ||= average_teams_opponent
  end

  def average_teams_opponent #helper method for all teams opponent averages
    all_teams = {}

    @teams.each do |team|
      all_teams[team.team_id] = (team_opponent_goals(team.team_id))/game_count_by_team_id(team.team_id).to_f
    end
    all_teams
  end

  def game_teams_by_all_team_ids
    @game_teams.group_by do |game_team|
      game_team.team_id
    end
  end

  def game_teams_by_team_id(team_id) #returns game_team_instance
    game_teams_by_all_team_ids[team_id]
  end

  def team_total_score(team_id)
    game_teams_by_team_id(team_id).sum do |game|
      game.goals.to_i
    end
  end

  def average_score_by_team_id(team_id)
    team_total_score(team_id).to_f / game_count_by_team_id(team_id).to_f
  end

  def game_count_by_team_id(team_id)
    game_teams_by_team_id(team_id).count
  end


end
