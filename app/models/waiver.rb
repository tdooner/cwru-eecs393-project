class Waiver
  include MongoMapper::EmbeddedDocument
  plugin MongoMapper::Plugins::MultiParameterAttributes

  key :date_signed, Date
  key :date_of_birth, Date
  key :emergency_name, String
  key :emergency_phone, String

  embedded_in :player
end
