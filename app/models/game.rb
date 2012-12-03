class Game
  include MongoMapper::Document
  plugin MongoMapper::Plugins::MultiParameterAttributes

  key :name, String
  key :registration_begins, Time
  key :registration_ends, Time
  key :game_begins, Time
  key :game_ends, Time
  key :announcements, String

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

  def friendly_dates
    format = '%b %d %y @ %I:%M %p'

    @friendly_dates ||= [
      :game_begins,
      :game_ends,
      :registration_begins,
      :registration_ends,
    ].inject({}) { |h,i| h.merge(i => self.send(i).strftime(format)) }
  end

  def can_register?(user)
    # TODO: Cancan it
    !user.registered?(self) && (Time.now >= registration_begins) && (Time.now < registration_ends)
  end
end
