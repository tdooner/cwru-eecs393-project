# In the real app, values will be populated from the database instead of with
# attr_accessor.

class Player < Engine::Model
  #include MongoMapper::Document
  #
  #key :name, String
  attr_accessor :name   # Defines getter and setter for "Player name"
end
