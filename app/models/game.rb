class Game
  include MongoMapper::Document

  key :name, String
  key :registration_begins, Time
  key :registration_ends, Time
  key :game_begins, Time
  key :game_ends, Time

  many :all_player_objects, :class_name => 'Player'
  many :squads

  def players
    all_player_objects.where(registered: true)
  end
end
