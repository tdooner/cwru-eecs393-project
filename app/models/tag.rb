class Tag
  include MongoMapper::Document

  belongs_to :tagger, :foreign_key => 'tagger_id', :class_name => 'Player'
  belongs_to :tagged, :foreign_key => 'tagged_id', :class_name => 'Player'
  belongs_to :game

  key :datetime, Time
  key :score, Integer

  many :feeds
end
