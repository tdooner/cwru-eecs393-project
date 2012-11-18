# In the real app, values will be populated from the database instead of with
# attr_accessor.

class Player
  include MongoMapper::Document
  include ZombieGame::FilteredModel

  key :game_id, ObjectId
  key :user_id, ObjectId
  key :registered, Boolean
  key :off_campus, Boolean # via Engine plugin

  belongs_to :game
  belongs_to :user
  belongs_to :squad # via Engine plugin

  one :waiver # via Engine plugin

  ensure_index [[:game_id, 1], [:user_id, 1]], :unique => true
  ensure_index [[:registered, 1]]

  def signed_waiver?
    waiver.present?
  end

  def joined_squad?
    squad.present?
  end
end
