class StatTracker
  def initialize(file)
    @file = file
  end

  def self.from_csv(data)
    StatTracker.new(data)
  end
end
