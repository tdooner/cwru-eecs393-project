# In the real app, values will be populated from the database instead of with
# attr_accessor.

class Player
  include MongoMapper::Document
  include ZombieGame::FilteredModel

  key :game_id, ObjectId
  key :user_id, ObjectId
  key :registered, Boolean
  key :off_campus, Boolean # via Engine plugin
  key :oz, Boolean
  key :game_admin, Boolean
  key :points, Integer
  key :card_code, String

  belongs_to :game
  belongs_to :user
  belongs_to :squad # via Engine plugin

  one :waiver # via Engine plugin
  one :killing_tag, :foreign_key => 'tagged_id', :class_name => 'Tag'

  many :tags, :foreign_key => 'tagger_id', :class_name => 'Tag'
  many :feeds

  ensure_index [[:game_id, 1], [:user_id, 1]], :unique => true
  ensure_index [[:registered, 1]]
  ensure_index [[:points, -1]]

  def signed_waiver?
    waiver.present? && waiver.valid?
  end

  def joined_squad?
    squad.present?
  end

  # Utility method for state_if_tagged. Perhaps should not exist once it is
  # moved into the engine.
  def tagged?
    game.tags.where(:tagged_id => self._id).exists?
  end

  # Utility method for state_if_starved. Perhaps should not exist once it is
  # moved into the engine.
  def feed_times
    (tags + feeds + [killing_tag].compact).map(&:datetime)
  end

  def state
    # TODO: Eventually have this cached as a field, kept up-to-date by the
    # Engine.
    #
    # "steps" is the equivalent of the functions registered by plugins for the
    # "get_state" hook (or whatever it is to be called)
    #
    # Each of these functions should take three arguments:
    #   player      the player object
    #               (Note: this is kind of useless for now but
    #               eventually it will be useful because plugins won't be in the
    #               Player model)
    #   state       the current state at this point in the chain. defaults to
    #               human
    #   game_time   the game time for which the calculation should be
    #               performed
    steps = [:state_if_tagged, :state_if_oz, :state_if_offcampus, :state_if_starved]

    game_time = self.game.time
    start_state = :human

    @state ||= steps.inject(start_state) { |state,i| self.send(i, self, state, game_time) }
  end

  def self.generate_card_code
    %W{A C D E F G H K L M P Q R T W X Y Z 2 3 4 5 6 7 8 9}.sample(5).join
  end

  private

  # In the engine, eventually:
  def state_if_tagged(player, state, time)
    if player.tagged? && state == :human
      :zombie
    else
      state
    end
  end

  # In the engine, eventually:
  #   Note: This plugin serves only to convert OZs to "zombie" because they
  #   aren't explicitly tagged. It is *not* a display filter.
  def state_if_oz(player, state, time)
    if player.oz && state == :human
      :zombie
    else
      state
    end
  end

  # In the engine, eventually:
  def state_if_offcampus(player, state, time)
    return state unless player.off_campus

    # Checkins are not implemented yet
    return state if player.off_campus
  end

  # In the engine, eventually:
  def state_if_starved(player, state, time)
    return state unless state == :zombie

    if ((time - feed_times.max) / 1.hour >= 48)
      :deceased
    else
      :zombie
    end
  end
end
