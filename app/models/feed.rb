class Feed
  include MongoMapper::EmbeddedDocument

  key :datetime

  belongs_to :tag
end
