class Game
  include MongoMapper::Document

  key :name, String
  key :registration_begins, Time
  key :registration_ends, Time
  key :game_begins, Time
  key :game_ends, Time

  # Time zone is the name of an ActiveSupport::TimeZone instance. For example,
  # the US time zones are returned with ActiveSupport::TimeZone.us_zones, the
  # result from the `name' method should be saved in this property.
  key :time_zone, String

  many :all_player_objects, :class_name => 'Player'
  many :squads
  many :tags

  def players
    all_player_objects.where(registered: true)
  end

  # Returns the effective game-time. This is bounded by game_begins and
  # game_ends.
  def time
    [self.game_begins, [self.game_ends, Time.now].min].max
  end
end
