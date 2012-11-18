# In the real app, values will be populated from the database instead of with
# attr_accessor.

class Player
  include MongoMapper::Document
  include ZombieGame::FilteredModel

  key :game_id
  key :user_id

  belongs_to :game
  belongs_to :user

  ensure_index [[:game_id, 1], [:user_id, 1]], :unique => true
end
