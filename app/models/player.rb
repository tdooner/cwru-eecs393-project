# In the real app, values will be populated from the database instead of with
# attr_accessor.

class Player
  include MongoMapper::Document
  include ZombieGame::FilteredModel

  key :name, String
  key :caseid, String
end
