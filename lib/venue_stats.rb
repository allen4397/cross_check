module VenueStats

  def most_popular_venue
    most_popular = game_count_by_venue.max_by do |venue_count|
      venue_count.last
    end
    return most_popular.first
  end

  def least_popular_venue
    least_popular = game_count_by_venue.min_by do |venue_count|
      venue_count.last
    end
    return least_popular.first
  end

  def game_count_by_venue
    venue_events = @games.group_by do |game|
      game.venue
    end
    venue_events.map do |venue, games|
      [venue, games.count]
    end
  end

end
