class Squad
  include MongoMapper::Document

  key :name, String

  many :players
  belongs_to :game

  ensure_index [[:game_id, 1], [:name, 1]], :unique => true
end
