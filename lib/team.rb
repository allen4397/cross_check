require "csv"

class Team
  def initialize(team_info)
    @team_id = team_info[:team_id]
    @franchise_id = team_info[:franchiseId]
    @short_name = team_info[:shortName]
    @team_name = team_info[:teamName]
    @abbreviation = team_info[:abbreviation]
    @link = team_info[:link]
  end
end
