require "csv"
require 'pry'

class Team

  def initialize(team_info)
    @team_id = team_info[:team_id]
    @franchise_id = team_info[:franchiseid]
    @short_name = team_info[:shortname]
    @team_name = team_info[:teamname]
    @abbreviation = team_info[:abbreviation]
    @link = team_info[:link]
  end

  def team_info
    { team_id: @team_id,
                  franchise_id: @franchise_id,
                  short_name: @short_name,
                  team_name: @team_name,
                  abbreviation: @abbreviation,
                  link: @link}

  end

end
