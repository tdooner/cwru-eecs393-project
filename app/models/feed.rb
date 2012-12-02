class Feed
  include MongoMapper::EmbeddedDocument

  belongs_to :fed_by, :class_name => 'Player'
  has_many :players_fed, :class_name => 'Player'

  embedded_in :tag
end
