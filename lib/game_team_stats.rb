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

  def game_count_by_team_id(team_id)
    game_teams_by_team_id(team_id).count
  end

end
