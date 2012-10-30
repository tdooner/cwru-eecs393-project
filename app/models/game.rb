class Game
  include MongoMapper::Document

  key :name, String
  key :registration_begins, Time
  key :registration_ends, Time
  key :game_begins, Time
  key :game_ends, Time

  many :players
end
