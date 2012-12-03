class Waiver
  include MongoMapper::EmbeddedDocument
  plugin MongoMapper::Plugins::MultiParameterAttributes

  key :date_signed, Date
  key :date_of_birth, Date
  key :emergency_name, String
  key :emergency_phone, String

  validates_presence_of :date_signed, :date_of_birth, :emergency_name,
    :emergency_phone

  embedded_in :player
end
